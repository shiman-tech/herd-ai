import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/breed_prediction.dart';
import '../models/cattle_image.dart';
import '../models/cattle_record.dart';
import '../models/embedding_reference.dart';
import '../models/identification_result.dart';
import '../utils/math_utils.dart';
import 'tflite_embedding_service.dart';

class EmbeddingDatabase {
  static const String _dbFileName = 'herd_ai.db';
  static const String _legacyJsonFileName = 'cattle_records.json';
  static const String _imageDirName = 'cattle_images';
  static const int _dbVersion = 7;

  /// Scores at or above this (but below [similarityThreshold]) trigger a
  /// pre-registration warning because the photo may match an existing cattle.
  static const double preRegistrationWarningThreshold =
      IdentificationResult.borderlineThreshold;

  final Map<String, CattleRecord> _recordsByCattle = <String, CattleRecord>{};

  final double similarityThreshold;

  Database? _db;

  EmbeddingDatabase({this.similarityThreshold = 0.75});

  int get totalEmbeddings => _recordsByCattle.values.fold<int>(
    0,
    (int total, CattleRecord cattle) => total + cattle.embeddings.length,
  );

  int get totalCattle => _recordsByCattle.length;

  bool get isEmpty => _recordsByCattle.isEmpty;

  List<CattleRecord> getAllCattle() {
    final List<CattleRecord> items = _recordsByCattle.values.toList();
    items.sort(
      (CattleRecord a, CattleRecord b) =>
          b.registrationDate.compareTo(a.registrationDate),
    );
    return items;
  }

  CattleRecord? getCattle(String cattleId) => _recordsByCattle[cattleId];

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  Future<void> load() async {
    _db = await _openDatabase();
    await _migrateFromJsonIfNeeded();
    await _loadAllIntoMemory();
    _repairImagePaths();
    await _purgeEmbeddingsForMissingPhotos();
    await _repairPhotoEmbeddingLinks();
    await _removeOrphanEmbeddings();
  }

  Future<Database> _openDatabase() async {
    final Directory docs = await getApplicationDocumentsDirectory();
    final String dbPath = p.join(docs.path, _dbFileName);
    return openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        await _createTables(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 6) {
          // Drop all old tables to start fresh
          await db.execute('DROP TABLE IF EXISTS cows');
          await db.execute('DROP TABLE IF EXISTS cattle');
          await db.execute('DROP TABLE IF EXISTS embeddings');
          await db.execute('DROP TABLE IF EXISTS health_records');
          await db.execute('DROP TABLE IF EXISTS vaccinations');
          await db.execute('DROP TABLE IF EXISTS notes');
          await db.execute('DROP TABLE IF EXISTS images');
          await _createTables(db);
          return;
        }
        if (oldVersion < 7) {
          await db.execute('ALTER TABLE cattle ADD COLUMN sex TEXT');
          await db.execute('ALTER TABLE cattle ADD COLUMN date_of_birth TEXT');
          await db.execute('ALTER TABLE cattle ADD COLUMN life_stage TEXT');
          await db.execute('ALTER TABLE cattle ADD COLUMN health_status TEXT');
          await db.execute('ALTER TABLE cattle ADD COLUMN reproductive_status TEXT');
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    final Batch batch = db.batch();
    batch.execute('''
      CREATE TABLE IF NOT EXISTS cattle (
        id TEXT PRIMARY KEY,
        registration_date TEXT NOT NULL,
        profile_image_path TEXT,
        breed_name TEXT,
        breed_confidence REAL,
        breed_alternatives_json TEXT,
        confirmed_breed TEXT,
        breed_confirmed_by_user INTEGER NOT NULL DEFAULT 0,
        sex TEXT,
        date_of_birth TEXT,
        life_stage TEXT,
        health_status TEXT,
        reproductive_status TEXT
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS embeddings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cattle_id TEXT NOT NULL,
        vector TEXT NOT NULL,
        source_image_path TEXT,
        image_id INTEGER,
        FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE,
        FOREIGN KEY (image_id) REFERENCES images(id) ON DELETE CASCADE
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cattle_id TEXT NOT NULL,
        disease_name TEXT NOT NULL DEFAULT '',
        date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Ongoing',
        symptoms TEXT NOT NULL DEFAULT '',
        treatment_notes TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS vaccinations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cattle_id TEXT NOT NULL,
        vaccine_name TEXT NOT NULL DEFAULT '',
        date_given TEXT NOT NULL,
        next_due_date TEXT,
        notes TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cattle_id TEXT NOT NULL,
        content TEXT NOT NULL,
        FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cattle_id TEXT NOT NULL,
        path TEXT NOT NULL,
        uploaded_at TEXT NOT NULL,
        FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE
      )
    ''');
    await batch.commit(noResult: true);
  }

  // ---------------------------------------------------------------------------
  // JSON migration
  // ---------------------------------------------------------------------------

  Future<void> _migrateFromJsonIfNeeded() async {
    final Directory docs = await getApplicationDocumentsDirectory();
    final File jsonFile = File(
      p.join(docs.path, _legacyJsonFileName),
    );
    if (!await jsonFile.exists()) {
      return;
    }

    final String content = await jsonFile.readAsString();
    if (content.trim().isEmpty) {
      await jsonFile.rename(p.join(docs.path, '$_legacyJsonFileName.migrated'));
      return;
    }

    final Map<String, CattleRecord> legacy = _parseJsonContent(content);

    final Database db = _db!;
    await db.transaction((Transaction txn) async {
      for (final MapEntry<String, CattleRecord> entry in legacy.entries) {
        final CattleRecord cattle = entry.value;

        await txn.insert(
          'cattle',
          <String, Object?>{
            'id': cattle.id,
            'registration_date': cattle.registrationDate.toIso8601String(),
            'profile_image_path': cattle.profileImagePath,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        for (final EmbeddingReference embedding in cattle.embeddings) {
          await txn.insert('embeddings', <String, Object?>{
            'cattle_id': cattle.id,
            'vector': jsonEncode(embedding.vector),
            'source_image_path': embedding.sourceImagePath,
          });
        }

        for (final HealthRecord hr in cattle.healthRecords) {
          await txn.insert('health_records', <String, Object?>{
            'cattle_id': cattle.id,
            'disease_name': hr.diseaseName,
            'date': hr.date.toIso8601String(),
            'status': hr.status,
            'symptoms': hr.symptoms,
            'treatment_notes': hr.treatmentNotes,
          });
        }

        for (final VaccinationRecord vr in cattle.vaccinations) {
          await txn.insert('vaccinations', <String, Object?>{
            'cattle_id': cattle.id,
            'vaccine_name': vr.vaccineName,
            'date_given': vr.dateGiven.toIso8601String(),
            'next_due_date': vr.nextDueDate?.toIso8601String(),
            'notes': vr.notes,
          });
        }

        for (final String note in cattle.notes) {
          await txn.insert('notes', <String, Object?>{
            'cattle_id': cattle.id,
            'content': note,
          });
        }

        for (final CattleImage image in cattle.images) {
          await txn.insert('images', <String, Object?>{
            'cattle_id': cattle.id,
            'path': image.path,
            'uploaded_at': image.uploadedAt.toIso8601String(),
          });
        }
      }
    });

    await jsonFile.rename(p.join(docs.path, '$_legacyJsonFileName.migrated'));
  }

  /// Parses legacy JSON content into a map of CattleRecords.
  /// Supports both the newer `{ "records": { ... } }` format and the older
  /// flat `{ cattleId: [[embedding], ...] }` format.
  Map<String, CattleRecord> _parseJsonContent(String content) {
    final Map<String, CattleRecord> result = <String, CattleRecord>{};

    final dynamic decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      return result;
    }

    if (decoded['records'] is Map<String, dynamic>) {
      final Map<String, dynamic> records =
          decoded['records'] as Map<String, dynamic>;
      for (final MapEntry<String, dynamic> entry in records.entries) {
        result[entry.key] = CattleRecord.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
      return result;
    }

    // Backward compatibility with older "cattleId -> embeddings" format.
    for (final MapEntry<String, dynamic> entry in decoded.entries) {
      final List<EmbeddingReference> embeddings =
          (entry.value as List<dynamic>)
              .map(
                (dynamic row) => EmbeddingReference.fromLegacyVector(
                  (row as List<dynamic>)
                      .map((dynamic value) => (value as num).toDouble())
                      .toList(),
                ),
              )
              .toList();
      result[entry.key] = CattleRecord(
        id: entry.key,
        registrationDate: DateTime.now(),
        embeddings: embeddings,
      );
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // Load from SQLite into memory
  // ---------------------------------------------------------------------------

  Future<void> _loadAllIntoMemory() async {
    _recordsByCattle.clear();
    final Database db = _db!;

    final List<Map<String, Object?>> cattleRows = await db.query('cattle');
    for (final Map<String, Object?> row in cattleRows) {
      final String cattleId = row['id']! as String;
      final CattleRecord record = CattleRecord(
        id: cattleId,
        registrationDate: DateTime.tryParse(
              row['registration_date'] as String? ?? '',
            ) ??
            DateTime.now(),
        profileImagePath: row['profile_image_path'] as String?,
        breedName: row['breed_name'] as String?,
        breedConfidence: (row['breed_confidence'] as num?)?.toDouble(),
        breedAlternativesJson: row['breed_alternatives_json'] as String?,
        confirmedBreed: row['confirmed_breed'] as String?,
        breedConfirmedByUser:
            ((row['breed_confirmed_by_user'] as int?) ?? 0) == 1,
        sex: row['sex'] as String?,
        dateOfBirth: DateTime.tryParse(row['date_of_birth'] as String? ?? ''),
        lifeStage: row['life_stage'] as String?,
        healthStatus: row['health_status'] as String?,
        reproductiveStatus: row['reproductive_status'] as String?,
      );
      _recordsByCattle[cattleId] = record;
    }

    final List<Map<String, Object?>> healthRows = await db.query(
      'health_records',
    );
    for (final Map<String, Object?> row in healthRows) {
      final String cattleId = row['cattle_id']! as String;
      final CattleRecord? record = _recordsByCattle[cattleId];
      if (record == null) {
        continue;
      }
      record.healthRecords.add(HealthRecord(
        diseaseName: row['disease_name'] as String? ?? '',
        date:
            DateTime.tryParse(row['date'] as String? ?? '') ?? DateTime.now(),
        status: row['status'] as String? ?? 'Ongoing',
        symptoms: row['symptoms'] as String? ?? '',
        treatmentNotes: row['treatment_notes'] as String? ?? '',
      ));
    }

    final List<Map<String, Object?>> vaccinationRows = await db.query(
      'vaccinations',
    );
    for (final Map<String, Object?> row in vaccinationRows) {
      final String cattleId = row['cattle_id']! as String;
      final CattleRecord? record = _recordsByCattle[cattleId];
      if (record == null) {
        continue;
      }
      record.vaccinations.add(VaccinationRecord(
        vaccineName: row['vaccine_name'] as String? ?? '',
        dateGiven:
            DateTime.tryParse(row['date_given'] as String? ?? '') ??
                DateTime.now(),
        nextDueDate:
            DateTime.tryParse(row['next_due_date'] as String? ?? ''),
        notes: row['notes'] as String? ?? '',
      ));
    }

    final List<Map<String, Object?>> noteRows = await db.query('notes');
    for (final Map<String, Object?> row in noteRows) {
      final String cattleId = row['cattle_id']! as String;
      final CattleRecord? record = _recordsByCattle[cattleId];
      if (record == null) {
        continue;
      }
      record.notes.add(row['content']! as String);
    }

    final List<Map<String, Object?>> imageRows = await db.query('images');
    for (final Map<String, Object?> row in imageRows) {
      final String cattleId = row['cattle_id']! as String;
      final CattleRecord? record = _recordsByCattle[cattleId];
      if (record == null) {
        continue;
      }
      record.images.add(
        CattleImage(
          id: row['id'] as int?,
          path: row['path']! as String,
          uploadedAt:
              DateTime.tryParse(row['uploaded_at'] as String? ?? '') ??
              DateTime.now(),
        ),
      );
    }

    final List<Map<String, Object?>> embeddingRows = await db.query(
      'embeddings',
    );
    for (final Map<String, Object?> row in embeddingRows) {
      final String cattleId = row['cattle_id']! as String;
      final CattleRecord? record = _recordsByCattle[cattleId];
      if (record == null) {
        continue;
      }
      final List<double> vector = (jsonDecode(row['vector']! as String)
              as List<dynamic>)
          .map((dynamic v) => (v as num).toDouble())
          .toList();
      record.embeddings.add(
        EmbeddingReference(
          id: row['id'] as int?,
          imageId: row['image_id'] as int?,
          vector: vector,
          sourceImagePath: row['source_image_path'] as String?,
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Register / Identify
  // ---------------------------------------------------------------------------

  Future<void> registerCattle({
    required String cattleId,
    required List<double> embedding,
    String? imagePath,
    String? note,
    String? sex,
    DateTime? dateOfBirth,
    String? lifeStage,
    String? healthStatus,
    String? reproductiveStatus,
  }) async {
    final Database db = _db!;
    final List<double> normalized = normalizeEmbedding(embedding);

    final CattleRecord record = _recordsByCattle.putIfAbsent(
      cattleId,
      () => CattleRecord(
        id: cattleId,
        registrationDate: DateTime.now(),
        sex: sex,
        dateOfBirth: dateOfBirth,
        lifeStage: lifeStage,
        healthStatus: healthStatus,
        reproductiveStatus: reproductiveStatus,
      ),
    );
    if (sex != null) record.sex = sex;
    if (dateOfBirth != null) record.dateOfBirth = dateOfBirth;
    if (lifeStage != null) record.lifeStage = lifeStage;
    if (healthStatus != null) record.healthStatus = healthStatus;
    if (reproductiveStatus != null) record.reproductiveStatus = reproductiveStatus;

    // Ensure cattle row exists in DB.
    await db.insert(
      'cattle',
      <String, Object?>{
        'id': record.id,
        'registration_date': record.registrationDate.toIso8601String(),
        'profile_image_path': record.profileImagePath,
        'sex': record.sex,
        'date_of_birth': record.dateOfBirth?.toIso8601String(),
        'life_stage': record.lifeStage,
        'health_status': record.healthStatus,
        'reproductive_status': record.reproductiveStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    String? savedImagePath;
    int? imageId;
    if (imagePath != null && imagePath.isNotEmpty) {
      final DateTime uploadedAt = DateTime.now();
      savedImagePath = await _persistImage(imagePath);
      imageId = await db.insert('images', <String, Object?>{
        'cattle_id': cattleId,
        'path': savedImagePath,
        'uploaded_at': uploadedAt.toIso8601String(),
      });
      record.profileImagePath ??= savedImagePath;
      record.images.add(
        CattleImage(
          id: imageId,
          path: savedImagePath,
          uploadedAt: uploadedAt,
        ),
      );
      await db.update(
        'cattle',
        <String, Object?>{'profile_image_path': record.profileImagePath},
        where: 'id = ?',
        whereArgs: <Object?>[cattleId],
      );
    }

    final int embeddingId = await db.insert('embeddings', <String, Object?>{
      'cattle_id': cattleId,
      'vector': jsonEncode(normalized),
      'source_image_path': savedImagePath,
      'image_id': imageId,
    });
    record.embeddings.add(
      EmbeddingReference(
        id: embeddingId,
        imageId: imageId,
        vector: normalized,
        sourceImagePath: savedImagePath,
      ),
    );

    // Handle note.
    if (note != null && note.trim().isNotEmpty) {
      record.notes.add(note.trim());
      await db.insert('notes', <String, Object?>{
        'cattle_id': cattleId,
        'content': note.trim(),
      });
    }
  }

  /// Saves a photo for [cattleId], stores the upload date, and links an
  /// embedding so the cattle can be identified from this photo.
  Future<void> addCattlePhoto({
    required String cattleId,
    required List<double> embedding,
    required String imagePath,
    DateTime? uploadedAt,
    bool isIdentity = true,
  }) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null || imagePath.isEmpty) {
      return;
    }

    final Database db = _db!;
    final List<double> normalized = normalizeEmbedding(embedding);
    final DateTime savedAt = uploadedAt ?? DateTime.now();
    final String savedPath = await _persistImage(imagePath);

    record.profileImagePath ??= savedPath;
    final int imageId = await db.insert('images', <String, Object?>{
      'cattle_id': cattleId,
      'path': savedPath,
      'uploaded_at': savedAt.toIso8601String(),
    });
    record.images.add(
      CattleImage(id: imageId, path: savedPath, uploadedAt: savedAt),
    );
    await db.update(
      'cattle',
      <String, Object?>{'profile_image_path': record.profileImagePath},
      where: 'id = ?',
      whereArgs: <Object?>[cattleId],
    );

    if (isIdentity) {
      final int embeddingId = await db.insert('embeddings', <String, Object?>{
        'cattle_id': cattleId,
        'vector': jsonEncode(normalized),
        'source_image_path': savedPath,
        'image_id': imageId,
      });
      record.embeddings.add(
        EmbeddingReference(
          id: embeddingId,
          imageId: imageId,
          vector: normalized,
          sourceImagePath: savedPath,
        ),
      );
    }
  }

  Future<void> _deleteEmbeddingsLinkedToPhoto(
    String cattleId,
    CattleImage photo, {
    required int photoIndexInRecord,
  }) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null) {
      return;
    }

    final Database db = _db!;
    final Set<int> embeddingIdsToDelete = <int>{};

    for (final EmbeddingReference ref in record.embeddings) {
      final bool matchesPath = ref.sourceImagePath == photo.path;
      final bool matchesImageId =
          photo.id != null && ref.imageId == photo.id;
      if (matchesPath || matchesImageId) {
        if (ref.id != null) {
          embeddingIdsToDelete.add(ref.id!);
        }
      }
    }

    if (embeddingIdsToDelete.isEmpty) {
      final List<EmbeddingReference> unlinked = record.embeddings
          .where((EmbeddingReference ref) => !_embeddingLinkedToLivePhoto(
                record,
                ref,
              ))
          .toList()
        ..sort(
          (EmbeddingReference a, EmbeddingReference b) =>
              (a.id ?? 0).compareTo(b.id ?? 0),
        );
      if (photoIndexInRecord >= 0 &&
          photoIndexInRecord < unlinked.length &&
          unlinked[photoIndexInRecord].id != null) {
        embeddingIdsToDelete.add(unlinked[photoIndexInRecord].id!);
      }
    }

    await db.delete(
      'embeddings',
      where: 'cattle_id = ? AND source_image_path = ?',
      whereArgs: <Object?>[cattleId, photo.path],
    );
    if (photo.id != null) {
      await db.delete(
        'embeddings',
        where: 'cattle_id = ? AND image_id = ?',
        whereArgs: <Object?>[cattleId, photo.id],
      );
    }
    for (final int embeddingId in embeddingIdsToDelete) {
      await db.delete(
        'embeddings',
        where: 'id = ? AND cattle_id = ?',
        whereArgs: <Object?>[embeddingId, cattleId],
      );
    }

    record.embeddings.removeWhere((EmbeddingReference ref) {
      if (ref.sourceImagePath == photo.path) {
        return true;
      }
      if (photo.id != null && ref.imageId == photo.id) {
        return true;
      }
      if (ref.id != null && embeddingIdsToDelete.contains(ref.id)) {
        return true;
      }
      return false;
    });
  }

  SimilarityMatch? findBestSimilarCattle(
    List<double> queryEmbedding, {
    String? excludeCattleId,
  }) {
    final List<double> normalized = normalizeEmbedding(queryEmbedding);

    String? bestCattleId;
    double bestScore = -1;

    for (final CattleRecord record in _recordsByCattle.values) {
      if (excludeCattleId != null && record.id == excludeCattleId) {
        continue;
      }
      for (final EmbeddingReference reference in record.embeddings) {
        final double score = cosineSimilarity(normalized, reference.vector);
        if (score > bestScore) {
          bestScore = score;
          bestCattleId = record.id;
        }
      }
    }

    if (bestCattleId == null || bestScore < preRegistrationWarningThreshold) {
      return null;
    }

    return SimilarityMatch(cattleId: bestCattleId, similarity: bestScore);
  }

  Future<IdentificationResult> predictCattle(
    File imageFile, {
    required TfliteEmbeddingService embeddingService,
  }) async {
    final List<double> queryEmbedding = await embeddingService.getEmbedding(
      imageFile,
    );

    String bestCattleId = 'Unknown';
    double bestScore = -1;

    for (final CattleRecord record in _recordsByCattle.values) {
      for (final EmbeddingReference reference in record.embeddings) {
        final double score = cosineSimilarity(queryEmbedding, reference.vector);
        if (score > bestScore) {
          bestScore = score;
          bestCattleId = record.id;
        }
      }
    }

    if (bestScore < similarityThreshold) {
      return IdentificationResult(
        predictedCattleId: 'Unknown',
        similarity: bestScore < 0 ? 0 : bestScore,
        isKnown: false,
        suggestedCattleId: bestScore >= 0 ? bestCattleId : null,
      );
    }

    return IdentificationResult(
      predictedCattleId: bestCattleId,
      similarity: bestScore,
      isKnown: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Health Records
  // ---------------------------------------------------------------------------

  Future<void> addHealthRecord(String cattleId, HealthRecord healthRecord) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null) {
      return;
    }
    record.healthRecords.add(healthRecord);
    await _db!.insert('health_records', <String, Object?>{
      'cattle_id': cattleId,
      'disease_name': healthRecord.diseaseName,
      'date': healthRecord.date.toIso8601String(),
      'status': healthRecord.status,
      'symptoms': healthRecord.symptoms,
      'treatment_notes': healthRecord.treatmentNotes,
    });
  }

  Future<void> updateHealthRecord({
    required String cattleId,
    required int index,
    required HealthRecord healthRecord,
  }) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null || index < 0 || index >= record.healthRecords.length) {
      return;
    }
    record.healthRecords[index] = healthRecord;
    await _replaceChildRows(
      cattleId: cattleId,
      table: 'health_records',
      rows: record.healthRecords
          .map((HealthRecord hr) => <String, Object?>{
                'cattle_id': cattleId,
                'disease_name': hr.diseaseName,
                'date': hr.date.toIso8601String(),
                'status': hr.status,
                'symptoms': hr.symptoms,
                'treatment_notes': hr.treatmentNotes,
              })
          .toList(),
    );
  }

  Future<void> deleteHealthRecord(String cattleId, int index) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null || index < 0 || index >= record.healthRecords.length) {
      return;
    }
    record.healthRecords.removeAt(index);
    await _replaceChildRows(
      cattleId: cattleId,
      table: 'health_records',
      rows: record.healthRecords
          .map((HealthRecord hr) => <String, Object?>{
                'cattle_id': cattleId,
                'disease_name': hr.diseaseName,
                'date': hr.date.toIso8601String(),
                'status': hr.status,
                'symptoms': hr.symptoms,
                'treatment_notes': hr.treatmentNotes,
              })
          .toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Vaccination Records
  // ---------------------------------------------------------------------------

  Future<void> addVaccinationRecord(
    String cattleId,
    VaccinationRecord vaccinationRecord,
  ) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null) {
      return;
    }
    record.vaccinations.add(vaccinationRecord);
    await _db!.insert('vaccinations', <String, Object?>{
      'cattle_id': cattleId,
      'vaccine_name': vaccinationRecord.vaccineName,
      'date_given': vaccinationRecord.dateGiven.toIso8601String(),
      'next_due_date': vaccinationRecord.nextDueDate?.toIso8601String(),
      'notes': vaccinationRecord.notes,
    });
  }

  Future<void> updateVaccinationRecord({
    required String cattleId,
    required int index,
    required VaccinationRecord vaccinationRecord,
  }) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null || index < 0 || index >= record.vaccinations.length) {
      return;
    }
    record.vaccinations[index] = vaccinationRecord;
    await _replaceChildRows(
      cattleId: cattleId,
      table: 'vaccinations',
      rows: record.vaccinations
          .map((VaccinationRecord vr) => <String, Object?>{
                'cattle_id': cattleId,
                'vaccine_name': vr.vaccineName,
                'date_given': vr.dateGiven.toIso8601String(),
                'next_due_date': vr.nextDueDate?.toIso8601String(),
                'notes': vr.notes,
              })
          .toList(),
    );
  }

  Future<void> deleteVaccinationRecord(String cattleId, int index) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null || index < 0 || index >= record.vaccinations.length) {
      return;
    }
    record.vaccinations.removeAt(index);
    await _replaceChildRows(
      cattleId: cattleId,
      table: 'vaccinations',
      rows: record.vaccinations
          .map((VaccinationRecord vr) => <String, Object?>{
                'cattle_id': cattleId,
                'vaccine_name': vr.vaccineName,
                'date_given': vr.dateGiven.toIso8601String(),
                'next_due_date': vr.nextDueDate?.toIso8601String(),
                'notes': vr.notes,
              })
          .toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Notes
  // ---------------------------------------------------------------------------

  Future<void> addNote(String cattleId, String note) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null || note.trim().isEmpty) {
      return;
    }
    record.notes.add(note.trim());
    await _db!.insert('notes', <String, Object?>{
      'cattle_id': cattleId,
      'content': note.trim(),
    });
  }

  Future<void> updateNote({
    required String cattleId,
    required int index,
    required String note,
  }) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null ||
        index < 0 ||
        index >= record.notes.length ||
        note.trim().isEmpty) {
      return;
    }
    record.notes[index] = note.trim();
    await _replaceChildRows(
      cattleId: cattleId,
      table: 'notes',
      rows: record.notes
          .map((String n) => <String, Object?>{
                'cattle_id': cattleId,
                'content': n,
              })
          .toList(),
    );
  }

  Future<void> deleteNote(String cattleId, int index) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null || index < 0 || index >= record.notes.length) {
      return;
    }
    record.notes.removeAt(index);
    await _replaceChildRows(
      cattleId: cattleId,
      table: 'notes',
      rows: record.notes
          .map((String n) => <String, Object?>{
                'cattle_id': cattleId,
                'content': n,
              })
          .toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Images
  // ---------------------------------------------------------------------------

  Future<void> replaceCattlePhoto({
    required String cattleId,
    required int index,
    required List<double> embedding,
    required String imagePath,
  }) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null ||
        index < 0 ||
        index >= record.images.length ||
        imagePath.isEmpty) {
      return;
    }

    final CattleImage oldPhoto = record.images[index];
    await _deleteEmbeddingsLinkedToPhoto(
      cattleId,
      oldPhoto,
      photoIndexInRecord: index,
    );

    final DateTime uploadedAt = DateTime.now();
    final String savedPath = await _persistImage(imagePath);
    final int? imageId = oldPhoto.id;

    if (imageId != null) {
      await _db!.update(
        'images',
        <String, Object?>{
          'path': savedPath,
          'uploaded_at': uploadedAt.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: <Object?>[imageId],
      );
    } else {
      await _db!.delete(
        'images',
        where: 'cattle_id = ? AND path = ?',
        whereArgs: <Object?>[cattleId, oldPhoto.path],
      );
      final int newImageId = await _db!.insert('images', <String, Object?>{
        'cattle_id': cattleId,
        'path': savedPath,
        'uploaded_at': uploadedAt.toIso8601String(),
      });
      record.images[index] = CattleImage(
        id: newImageId,
        path: savedPath,
        uploadedAt: uploadedAt,
      );
    }

    if (imageId != null) {
      record.images[index] = CattleImage(
        id: imageId,
        path: savedPath,
        uploadedAt: uploadedAt,
      );
    }

    if (record.profileImagePath == oldPhoto.path) {
      record.profileImagePath = savedPath;
    }

    await _db!.update(
      'cattle',
      <String, Object?>{'profile_image_path': record.profileImagePath},
      where: 'id = ?',
      whereArgs: <Object?>[cattleId],
    );

    final List<double> normalized = normalizeEmbedding(embedding);
    final int? linkedImageId = record.images[index].id;
    final int embeddingId = await _db!.insert('embeddings', <String, Object?>{
      'cattle_id': cattleId,
      'vector': jsonEncode(normalized),
      'source_image_path': savedPath,
      'image_id': linkedImageId,
    });
    record.embeddings.add(
      EmbeddingReference(
        id: embeddingId,
        imageId: linkedImageId,
        vector: normalized,
        sourceImagePath: savedPath,
      ),
    );

    if (oldPhoto.path != savedPath && File(oldPhoto.path).existsSync()) {
      await File(oldPhoto.path).delete();
    }
  }

  Future<void> deleteImage(String cattleId, int index) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null || index < 0 || index >= record.images.length) {
      return;
    }

    final CattleImage removed = record.images[index];
    await _deleteEmbeddingsLinkedToPhoto(
      cattleId,
      removed,
      photoIndexInRecord: index,
    );

    record.images.removeAt(index);

    if (removed.id != null) {
      await _db!.delete(
        'images',
        where: 'id = ?',
        whereArgs: <Object?>[removed.id],
      );
    } else {
      await _db!.delete(
        'images',
        where: 'cattle_id = ? AND path = ?',
        whereArgs: <Object?>[cattleId, removed.path],
      );
    }

    if (record.profileImagePath == removed.path) {
      record.profileImagePath = record.images.isNotEmpty
          ? record.images.first.path
          : null;
    }

    await _db!.update(
      'cattle',
      <String, Object?>{'profile_image_path': record.profileImagePath},
      where: 'id = ?',
      whereArgs: <Object?>[cattleId],
    );

    if (File(removed.path).existsSync()) {
      await File(removed.path).delete();
    }
  }

  // ---------------------------------------------------------------------------
  // Cow-level updates
  // ---------------------------------------------------------------------------

  Future<void> updateCattleBasicInfo({
    required String oldCattleId,
    required String newCattleId,
    String? profileImagePath,
    String? sex,
    DateTime? dateOfBirth,
    String? lifeStage,
    String? healthStatus,
    String? reproductiveStatus,
  }) async {
    final CattleRecord? existing = _recordsByCattle[oldCattleId];
    if (existing == null) {
      return;
    }
    if (newCattleId.trim().isEmpty) {
      return;
    }

    final String trimmedId = newCattleId.trim();
    final CattleRecord updated = CattleRecord(
      id: trimmedId,
      registrationDate: existing.registrationDate,
      profileImagePath: profileImagePath ?? existing.profileImagePath,
      embeddings: existing.embeddings,
      healthRecords: existing.healthRecords,
      vaccinations: existing.vaccinations,
      notes: existing.notes,
      images: existing.images,
      breedName: existing.breedName,
      breedConfidence: existing.breedConfidence,
      breedAlternativesJson: existing.breedAlternativesJson,
      confirmedBreed: existing.confirmedBreed,
      breedConfirmedByUser: existing.breedConfirmedByUser,
      sex: sex ?? existing.sex,
      dateOfBirth: dateOfBirth ?? existing.dateOfBirth,
      lifeStage: lifeStage ?? existing.lifeStage,
      healthStatus: healthStatus ?? existing.healthStatus,
      reproductiveStatus: reproductiveStatus ?? existing.reproductiveStatus,
    );

    final Database db = _db!;
    await db.transaction((Transaction txn) async {
      // Insert the new cattle row first.
      await txn.insert(
        'cattle',
        <String, Object?>{
          'id': trimmedId,
          'registration_date':
              updated.registrationDate.toIso8601String(),
          'profile_image_path': updated.profileImagePath,
          'breed_name': updated.breedName,
          'breed_confidence': updated.breedConfidence,
          'breed_alternatives_json': updated.breedAlternativesJson,
          'confirmed_breed': updated.confirmedBreed,
          'breed_confirmed_by_user': updated.breedConfirmedByUser ? 1 : 0,
          'sex': updated.sex,
          'date_of_birth': updated.dateOfBirth?.toIso8601String(),
          'life_stage': updated.lifeStage,
          'health_status': updated.healthStatus,
          'reproductive_status': updated.reproductiveStatus,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Re-point all child rows from old cattle id to new cattle id.
      for (final String table in <String>[
        'embeddings',
        'health_records',
        'vaccinations',
        'notes',
        'images',
      ]) {
        await txn.update(
          table,
          <String, Object?>{'cattle_id': trimmedId},
          where: 'cattle_id = ?',
          whereArgs: <Object?>[oldCattleId],
        );
      }

      // Delete old cattle row (if the id actually changed).
      if (oldCattleId != trimmedId) {
        await txn.delete(
          'cattle',
          where: 'id = ?',
          whereArgs: <Object?>[oldCattleId],
        );
      }
    });

    if (oldCattleId != trimmedId) {
      _recordsByCattle.remove(oldCattleId);
    }
    _recordsByCattle[trimmedId] = updated;
  }

  // ---------------------------------------------------------------------------
  // Breed Classification
  // ---------------------------------------------------------------------------

  /// Saves the breed classification result for [cattleId] in memory and in SQLite.
  ///
  /// Calling this always resets any prior user confirmation so the user can
  /// review the new result and re-confirm if they wish.
  Future<void> saveBreedResult({
    required String cattleId,
    required String breedName,
    required double breedConfidence,
    required List<BreedPrediction> alternatives,
  }) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null) {
      return;
    }

    final String alternativesJson = jsonEncode(
      alternatives.map((BreedPrediction p) => p.toJson()).toList(),
    );

    record.breedName = breedName;
    record.breedConfidence = breedConfidence;
    record.breedAlternativesJson = alternativesJson;
    record.confirmedBreed = null;
    record.breedConfirmedByUser = false;

    await _db!.update(
      'cattle',
      <String, Object?>{
        'breed_name': breedName,
        'breed_confidence': breedConfidence,
        'breed_alternatives_json': alternativesJson,
        'confirmed_breed': null,
        'breed_confirmed_by_user': 0,
      },
      where: 'id = ?',
      whereArgs: <Object?>[cattleId],
    );
  }

  /// Saves the user-chosen breed override for [cattleId].
  ///
  /// This does NOT clear the model prediction — both can coexist.
  Future<void> confirmBreed({
    required String cattleId,
    required String confirmedBreed,
  }) async {
    final CattleRecord? record = _recordsByCattle[cattleId];
    if (record == null) {
      return;
    }

    record.confirmedBreed = confirmedBreed;
    record.breedConfirmedByUser = true;

    await _db!.update(
      'cattle',
      <String, Object?>{
        'confirmed_breed': confirmedBreed,
        'breed_confirmed_by_user': 1,
      },
      where: 'id = ?',
      whereArgs: <Object?>[cattleId],
    );
  }

  Future<void> deleteCattle(String cattleId) async {
    _recordsByCattle.remove(cattleId);

    final Database db = _db!;
    await db.transaction((Transaction txn) async {
      for (final String table in <String>[
        'embeddings',
        'health_records',
        'vaccinations',
        'notes',
        'images',
      ]) {
        await txn.delete(table, where: 'cattle_id = ?', whereArgs: <Object?>[cattleId]);
      }
      await txn.delete('cattle', where: 'id = ?', whereArgs: <Object?>[cattleId]);
    });
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Replaces all child rows for a given cattle in the specified table.
  /// Used for update/delete operations on ordered lists where we don't have
  /// stable row IDs mapped to in-memory indices.
  Future<void> _replaceChildRows({
    required String cattleId,
    required String table,
    required List<Map<String, Object?>> rows,
  }) async {
    final Database db = _db!;
    await db.transaction((Transaction txn) async {
      await txn.delete(table, where: 'cattle_id = ?', whereArgs: <Object?>[cattleId]);
      for (final Map<String, Object?> row in rows) {
        await txn.insert(table, row);
      }
    });
  }

  void _repairImagePaths() {
    for (final CattleRecord record in _recordsByCattle.values) {
      record.images.removeWhere(
        (CattleImage image) => !File(image.path).existsSync(),
      );
      if (record.profileImagePath != null &&
          !File(record.profileImagePath!).existsSync()) {
        record.profileImagePath = null;
      }
      if (record.profileImagePath == null && record.images.isNotEmpty) {
        record.profileImagePath = record.images.first.path;
      }
    }
  }

  Future<void> _purgeEmbeddingsForMissingPhotos() async {
    for (final CattleRecord record in _recordsByCattle.values) {
      final List<EmbeddingReference> stale = record.embeddings
          .where(
            (EmbeddingReference ref) =>
                !_embeddingLinkedToLivePhoto(record, ref),
          )
          .toList();
      for (final EmbeddingReference ref in stale) {
        record.embeddings.remove(ref);
        if (ref.id != null) {
          await _db!.delete(
            'embeddings',
            where: 'id = ?',
            whereArgs: <Object?>[ref.id],
          );
        }
      }
    }
  }

  Future<void> _repairPhotoEmbeddingLinks() async {
    final Database db = _db!;
    for (final CattleRecord record in _recordsByCattle.values) {
      final Set<String> pathsWithEmbedding = record.embeddings
          .map((EmbeddingReference ref) => ref.sourceImagePath)
          .whereType<String>()
          .where((String path) => path.isNotEmpty)
          .toSet();

      final List<CattleImage> photosNeedingLink = record.images
          .where((CattleImage img) => !pathsWithEmbedding.contains(img.path))
          .toList()
        ..sort(
          (CattleImage a, CattleImage b) => (a.id ?? 0).compareTo(b.id ?? 0),
        );

      final List<int> unlinkedEmbeddingIndexes = <int>[];
      for (int index = 0; index < record.embeddings.length; index++) {
        if (!_embeddingLinkedToLivePhoto(record, record.embeddings[index])) {
          unlinkedEmbeddingIndexes.add(index);
        }
      }

      for (int index = 0;
          index < photosNeedingLink.length &&
          index < unlinkedEmbeddingIndexes.length;
          index++) {
        final CattleImage photo = photosNeedingLink[index];
        final int embeddingIndex = unlinkedEmbeddingIndexes[index];
        final EmbeddingReference old = record.embeddings[embeddingIndex];
        record.embeddings[embeddingIndex] = old.copyWith(
          sourceImagePath: photo.path,
          imageId: photo.id,
        );
        if (old.id != null) {
          await db.update(
            'embeddings',
            <String, Object?>{
              'source_image_path': photo.path,
              'image_id': photo.id,
            },
            where: 'id = ?',
            whereArgs: <Object?>[old.id],
          );
        }
      }
    }
  }

  Future<void> _removeOrphanEmbeddings() async {
    for (final CattleRecord record in _recordsByCattle.values) {
      final List<EmbeddingReference> orphans = record.embeddings
          .where(
            (EmbeddingReference ref) =>
                !_embeddingLinkedToLivePhoto(record, ref),
          )
          .toList();
      for (final EmbeddingReference ref in orphans) {
        record.embeddings.remove(ref);
        if (ref.id != null) {
          await _db!.delete(
            'embeddings',
            where: 'id = ?',
            whereArgs: <Object?>[ref.id],
          );
        }
      }
    }
  }

  bool _embeddingLinkedToLivePhoto(
    CattleRecord record,
    EmbeddingReference ref,
  ) {
    if (ref.imageId != null &&
        record.images.any((CattleImage img) => img.id == ref.imageId)) {
      return true;
    }
    final String? path = ref.sourceImagePath;
    if (path != null &&
        path.isNotEmpty &&
        record.images.any((CattleImage img) => img.path == path)) {
      return true;
    }
    return false;
  }

  Future<String> _persistImage(String sourcePath) async {
    final File source = File(sourcePath);
    if (!await source.exists()) {
      return sourcePath;
    }
    final Directory docs = await getApplicationDocumentsDirectory();
    final Directory imageDir = Directory(
      p.join(docs.path, _imageDirName),
    );
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    final String extension = source.path.contains('.')
        ? source.path.substring(source.path.lastIndexOf('.'))
        : '.jpg';
    final String fileName =
        'cattle_${DateTime.now().microsecondsSinceEpoch}$extension';
    final String targetPath = p.join(imageDir.path, fileName);
    await source.copy(targetPath);
    return targetPath;
  }
}
