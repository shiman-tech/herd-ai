import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/breed_prediction.dart';
import '../models/cow_image.dart';
import '../models/cow_record.dart';
import '../models/embedding_reference.dart';
import '../models/identification_result.dart';
import '../utils/math_utils.dart';
import 'tflite_embedding_service.dart';

class EmbeddingDatabase {
  static const String _dbFileName = 'herd_ai.db';
  static const String _legacyJsonFileName = 'cow_records.json';
  static const String _imageDirName = 'cow_images';
  static const int _dbVersion = 5;

  /// Scores at or above this (but below [similarityThreshold]) trigger a
  /// pre-registration warning because the photo may match an existing cow.
  static const double preRegistrationWarningThreshold =
      IdentificationResult.borderlineThreshold;

  final Map<String, CowRecord> _recordsByCow = <String, CowRecord>{};

  final double similarityThreshold;

  Database? _db;

  EmbeddingDatabase({this.similarityThreshold = 0.75});

  int get totalEmbeddings => _recordsByCow.values.fold<int>(
    0,
    (int total, CowRecord cow) => total + cow.embeddings.length,
  );

  int get totalCows => _recordsByCow.length;

  bool get isEmpty => _recordsByCow.isEmpty;

  List<CowRecord> getAllCows() {
    final List<CowRecord> items = _recordsByCow.values.toList();
    items.sort(
      (CowRecord a, CowRecord b) =>
          b.registrationDate.compareTo(a.registrationDate),
    );
    return items;
  }

  CowRecord? getCow(String cowId) => _recordsByCow[cowId];

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
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE embeddings ADD COLUMN source_image_path TEXT',
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE images ADD COLUMN uploaded_at TEXT',
          );
          await db.execute(
            "UPDATE images SET uploaded_at = datetime('now') "
            'WHERE uploaded_at IS NULL',
          );
        }
        if (oldVersion < 4) {
          await db.execute(
            'ALTER TABLE embeddings ADD COLUMN image_id INTEGER',
          );
        }
        if (oldVersion < 5) {
          await db.execute(
            'ALTER TABLE cows ADD COLUMN breed_name TEXT',
          );
          await db.execute(
            'ALTER TABLE cows ADD COLUMN breed_confidence REAL',
          );
          await db.execute(
            'ALTER TABLE cows ADD COLUMN breed_alternatives_json TEXT',
          );
          await db.execute(
            'ALTER TABLE cows ADD COLUMN confirmed_breed TEXT',
          );
          await db.execute(
            'ALTER TABLE cows ADD COLUMN breed_confirmed_by_user INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    final Batch batch = db.batch();
    batch.execute('''
      CREATE TABLE IF NOT EXISTS cows (
        id TEXT PRIMARY KEY,
        registration_date TEXT NOT NULL,
        profile_image_path TEXT,
        breed_name TEXT,
        breed_confidence REAL,
        breed_alternatives_json TEXT,
        confirmed_breed TEXT,
        breed_confirmed_by_user INTEGER NOT NULL DEFAULT 0
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS embeddings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cow_id TEXT NOT NULL,
        vector TEXT NOT NULL,
        source_image_path TEXT,
        image_id INTEGER,
        FOREIGN KEY (cow_id) REFERENCES cows(id) ON DELETE CASCADE,
        FOREIGN KEY (image_id) REFERENCES images(id) ON DELETE CASCADE
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cow_id TEXT NOT NULL,
        disease_name TEXT NOT NULL DEFAULT '',
        date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Ongoing',
        symptoms TEXT NOT NULL DEFAULT '',
        treatment_notes TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (cow_id) REFERENCES cows(id) ON DELETE CASCADE
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS vaccinations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cow_id TEXT NOT NULL,
        vaccine_name TEXT NOT NULL DEFAULT '',
        date_given TEXT NOT NULL,
        next_due_date TEXT,
        notes TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (cow_id) REFERENCES cows(id) ON DELETE CASCADE
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cow_id TEXT NOT NULL,
        content TEXT NOT NULL,
        FOREIGN KEY (cow_id) REFERENCES cows(id) ON DELETE CASCADE
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cow_id TEXT NOT NULL,
        path TEXT NOT NULL,
        uploaded_at TEXT NOT NULL,
        FOREIGN KEY (cow_id) REFERENCES cows(id) ON DELETE CASCADE
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

    final Map<String, CowRecord> legacy = _parseJsonContent(content);

    final Database db = _db!;
    await db.transaction((Transaction txn) async {
      for (final MapEntry<String, CowRecord> entry in legacy.entries) {
        final CowRecord cow = entry.value;

        await txn.insert(
          'cows',
          <String, Object?>{
            'id': cow.id,
            'registration_date': cow.registrationDate.toIso8601String(),
            'profile_image_path': cow.profileImagePath,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        for (final EmbeddingReference embedding in cow.embeddings) {
          await txn.insert('embeddings', <String, Object?>{
            'cow_id': cow.id,
            'vector': jsonEncode(embedding.vector),
            'source_image_path': embedding.sourceImagePath,
          });
        }

        for (final HealthRecord hr in cow.healthRecords) {
          await txn.insert('health_records', <String, Object?>{
            'cow_id': cow.id,
            'disease_name': hr.diseaseName,
            'date': hr.date.toIso8601String(),
            'status': hr.status,
            'symptoms': hr.symptoms,
            'treatment_notes': hr.treatmentNotes,
          });
        }

        for (final VaccinationRecord vr in cow.vaccinations) {
          await txn.insert('vaccinations', <String, Object?>{
            'cow_id': cow.id,
            'vaccine_name': vr.vaccineName,
            'date_given': vr.dateGiven.toIso8601String(),
            'next_due_date': vr.nextDueDate?.toIso8601String(),
            'notes': vr.notes,
          });
        }

        for (final String note in cow.notes) {
          await txn.insert('notes', <String, Object?>{
            'cow_id': cow.id,
            'content': note,
          });
        }

        for (final CowImage image in cow.images) {
          await txn.insert('images', <String, Object?>{
            'cow_id': cow.id,
            'path': image.path,
            'uploaded_at': image.uploadedAt.toIso8601String(),
          });
        }
      }
    });

    await jsonFile.rename(p.join(docs.path, '$_legacyJsonFileName.migrated'));
  }

  /// Parses legacy JSON content into a map of CowRecords.
  /// Supports both the newer `{ "records": { ... } }` format and the older
  /// flat `{ cowId: [[embedding], ...] }` format.
  Map<String, CowRecord> _parseJsonContent(String content) {
    final Map<String, CowRecord> result = <String, CowRecord>{};

    final dynamic decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      return result;
    }

    if (decoded['records'] is Map<String, dynamic>) {
      final Map<String, dynamic> records =
          decoded['records'] as Map<String, dynamic>;
      for (final MapEntry<String, dynamic> entry in records.entries) {
        result[entry.key] = CowRecord.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
      return result;
    }

    // Backward compatibility with older "cowId -> embeddings" format.
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
      result[entry.key] = CowRecord(
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
    _recordsByCow.clear();
    final Database db = _db!;

    final List<Map<String, Object?>> cowRows = await db.query('cows');
    for (final Map<String, Object?> row in cowRows) {
      final String cowId = row['id']! as String;
      final CowRecord record = CowRecord(
        id: cowId,
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
      );
      _recordsByCow[cowId] = record;
    }

    final List<Map<String, Object?>> healthRows = await db.query(
      'health_records',
    );
    for (final Map<String, Object?> row in healthRows) {
      final String cowId = row['cow_id']! as String;
      final CowRecord? record = _recordsByCow[cowId];
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
      final String cowId = row['cow_id']! as String;
      final CowRecord? record = _recordsByCow[cowId];
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
      final String cowId = row['cow_id']! as String;
      final CowRecord? record = _recordsByCow[cowId];
      if (record == null) {
        continue;
      }
      record.notes.add(row['content']! as String);
    }

    final List<Map<String, Object?>> imageRows = await db.query('images');
    for (final Map<String, Object?> row in imageRows) {
      final String cowId = row['cow_id']! as String;
      final CowRecord? record = _recordsByCow[cowId];
      if (record == null) {
        continue;
      }
      record.images.add(
        CowImage(
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
      final String cowId = row['cow_id']! as String;
      final CowRecord? record = _recordsByCow[cowId];
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

  Future<void> registerCow({
    required String cowId,
    required List<double> embedding,
    String? imagePath,
    String? note,
  }) async {
    final Database db = _db!;
    final List<double> normalized = normalizeEmbedding(embedding);

    final CowRecord record = _recordsByCow.putIfAbsent(
      cowId,
      () => CowRecord(id: cowId, registrationDate: DateTime.now()),
    );

    // Ensure cow row exists in DB.
    await db.insert(
      'cows',
      <String, Object?>{
        'id': record.id,
        'registration_date': record.registrationDate.toIso8601String(),
        'profile_image_path': record.profileImagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    String? savedImagePath;
    int? imageId;
    if (imagePath != null && imagePath.isNotEmpty) {
      final DateTime uploadedAt = DateTime.now();
      savedImagePath = await _persistImage(imagePath);
      imageId = await db.insert('images', <String, Object?>{
        'cow_id': cowId,
        'path': savedImagePath,
        'uploaded_at': uploadedAt.toIso8601String(),
      });
      record.profileImagePath ??= savedImagePath;
      record.images.add(
        CowImage(
          id: imageId,
          path: savedImagePath,
          uploadedAt: uploadedAt,
        ),
      );
      await db.update(
        'cows',
        <String, Object?>{'profile_image_path': record.profileImagePath},
        where: 'id = ?',
        whereArgs: <Object?>[cowId],
      );
    }

    final int embeddingId = await db.insert('embeddings', <String, Object?>{
      'cow_id': cowId,
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
        'cow_id': cowId,
        'content': note.trim(),
      });
    }
  }

  /// Saves a photo for [cowId], stores the upload date, and links an
  /// embedding so the cow can be identified from this photo.
  Future<void> addCowPhoto({
    required String cowId,
    required List<double> embedding,
    required String imagePath,
    DateTime? uploadedAt,
  }) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || imagePath.isEmpty) {
      return;
    }

    final Database db = _db!;
    final List<double> normalized = normalizeEmbedding(embedding);
    final DateTime savedAt = uploadedAt ?? DateTime.now();
    final String savedPath = await _persistImage(imagePath);

    record.profileImagePath ??= savedPath;
    final int imageId = await db.insert('images', <String, Object?>{
      'cow_id': cowId,
      'path': savedPath,
      'uploaded_at': savedAt.toIso8601String(),
    });
    record.images.add(
      CowImage(id: imageId, path: savedPath, uploadedAt: savedAt),
    );
    await db.update(
      'cows',
      <String, Object?>{'profile_image_path': record.profileImagePath},
      where: 'id = ?',
      whereArgs: <Object?>[cowId],
    );

    final int embeddingId = await db.insert('embeddings', <String, Object?>{
      'cow_id': cowId,
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

  Future<void> _deleteEmbeddingsLinkedToPhoto(
    String cowId,
    CowImage photo, {
    required int photoIndexInRecord,
  }) async {
    final CowRecord? record = _recordsByCow[cowId];
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
      where: 'cow_id = ? AND source_image_path = ?',
      whereArgs: <Object?>[cowId, photo.path],
    );
    if (photo.id != null) {
      await db.delete(
        'embeddings',
        where: 'cow_id = ? AND image_id = ?',
        whereArgs: <Object?>[cowId, photo.id],
      );
    }
    for (final int embeddingId in embeddingIdsToDelete) {
      await db.delete(
        'embeddings',
        where: 'id = ? AND cow_id = ?',
        whereArgs: <Object?>[embeddingId, cowId],
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

  SimilarityMatch? findBestSimilarCow(
    List<double> queryEmbedding, {
    String? excludeCowId,
  }) {
    final List<double> normalized = normalizeEmbedding(queryEmbedding);

    String? bestCowId;
    double bestScore = -1;

    for (final CowRecord record in _recordsByCow.values) {
      if (excludeCowId != null && record.id == excludeCowId) {
        continue;
      }
      for (final EmbeddingReference reference in record.embeddings) {
        final double score = cosineSimilarity(normalized, reference.vector);
        if (score > bestScore) {
          bestScore = score;
          bestCowId = record.id;
        }
      }
    }

    if (bestCowId == null || bestScore < preRegistrationWarningThreshold) {
      return null;
    }

    return SimilarityMatch(cowId: bestCowId, similarity: bestScore);
  }

  Future<IdentificationResult> predictCow(
    File imageFile, {
    required TfliteEmbeddingService embeddingService,
  }) async {
    final List<double> queryEmbedding = await embeddingService.getEmbedding(
      imageFile,
    );

    String bestCowId = 'Unknown';
    double bestScore = -1;

    for (final CowRecord record in _recordsByCow.values) {
      for (final EmbeddingReference reference in record.embeddings) {
        final double score = cosineSimilarity(queryEmbedding, reference.vector);
        if (score > bestScore) {
          bestScore = score;
          bestCowId = record.id;
        }
      }
    }

    if (bestScore < similarityThreshold) {
      return IdentificationResult(
        predictedCowId: 'Unknown',
        similarity: bestScore < 0 ? 0 : bestScore,
        isKnown: false,
        suggestedCowId: bestScore >= 0 ? bestCowId : null,
      );
    }

    return IdentificationResult(
      predictedCowId: bestCowId,
      similarity: bestScore,
      isKnown: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Health Records
  // ---------------------------------------------------------------------------

  Future<void> addHealthRecord(String cowId, HealthRecord healthRecord) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null) {
      return;
    }
    record.healthRecords.add(healthRecord);
    await _db!.insert('health_records', <String, Object?>{
      'cow_id': cowId,
      'disease_name': healthRecord.diseaseName,
      'date': healthRecord.date.toIso8601String(),
      'status': healthRecord.status,
      'symptoms': healthRecord.symptoms,
      'treatment_notes': healthRecord.treatmentNotes,
    });
  }

  Future<void> updateHealthRecord({
    required String cowId,
    required int index,
    required HealthRecord healthRecord,
  }) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.healthRecords.length) {
      return;
    }
    record.healthRecords[index] = healthRecord;
    await _replaceChildRows(
      cowId: cowId,
      table: 'health_records',
      rows: record.healthRecords
          .map((HealthRecord hr) => <String, Object?>{
                'cow_id': cowId,
                'disease_name': hr.diseaseName,
                'date': hr.date.toIso8601String(),
                'status': hr.status,
                'symptoms': hr.symptoms,
                'treatment_notes': hr.treatmentNotes,
              })
          .toList(),
    );
  }

  Future<void> deleteHealthRecord(String cowId, int index) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.healthRecords.length) {
      return;
    }
    record.healthRecords.removeAt(index);
    await _replaceChildRows(
      cowId: cowId,
      table: 'health_records',
      rows: record.healthRecords
          .map((HealthRecord hr) => <String, Object?>{
                'cow_id': cowId,
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
    String cowId,
    VaccinationRecord vaccinationRecord,
  ) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null) {
      return;
    }
    record.vaccinations.add(vaccinationRecord);
    await _db!.insert('vaccinations', <String, Object?>{
      'cow_id': cowId,
      'vaccine_name': vaccinationRecord.vaccineName,
      'date_given': vaccinationRecord.dateGiven.toIso8601String(),
      'next_due_date': vaccinationRecord.nextDueDate?.toIso8601String(),
      'notes': vaccinationRecord.notes,
    });
  }

  Future<void> updateVaccinationRecord({
    required String cowId,
    required int index,
    required VaccinationRecord vaccinationRecord,
  }) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.vaccinations.length) {
      return;
    }
    record.vaccinations[index] = vaccinationRecord;
    await _replaceChildRows(
      cowId: cowId,
      table: 'vaccinations',
      rows: record.vaccinations
          .map((VaccinationRecord vr) => <String, Object?>{
                'cow_id': cowId,
                'vaccine_name': vr.vaccineName,
                'date_given': vr.dateGiven.toIso8601String(),
                'next_due_date': vr.nextDueDate?.toIso8601String(),
                'notes': vr.notes,
              })
          .toList(),
    );
  }

  Future<void> deleteVaccinationRecord(String cowId, int index) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.vaccinations.length) {
      return;
    }
    record.vaccinations.removeAt(index);
    await _replaceChildRows(
      cowId: cowId,
      table: 'vaccinations',
      rows: record.vaccinations
          .map((VaccinationRecord vr) => <String, Object?>{
                'cow_id': cowId,
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

  Future<void> addNote(String cowId, String note) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || note.trim().isEmpty) {
      return;
    }
    record.notes.add(note.trim());
    await _db!.insert('notes', <String, Object?>{
      'cow_id': cowId,
      'content': note.trim(),
    });
  }

  Future<void> updateNote({
    required String cowId,
    required int index,
    required String note,
  }) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null ||
        index < 0 ||
        index >= record.notes.length ||
        note.trim().isEmpty) {
      return;
    }
    record.notes[index] = note.trim();
    await _replaceChildRows(
      cowId: cowId,
      table: 'notes',
      rows: record.notes
          .map((String n) => <String, Object?>{
                'cow_id': cowId,
                'content': n,
              })
          .toList(),
    );
  }

  Future<void> deleteNote(String cowId, int index) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.notes.length) {
      return;
    }
    record.notes.removeAt(index);
    await _replaceChildRows(
      cowId: cowId,
      table: 'notes',
      rows: record.notes
          .map((String n) => <String, Object?>{
                'cow_id': cowId,
                'content': n,
              })
          .toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Images
  // ---------------------------------------------------------------------------

  Future<void> replaceCowPhoto({
    required String cowId,
    required int index,
    required List<double> embedding,
    required String imagePath,
  }) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null ||
        index < 0 ||
        index >= record.images.length ||
        imagePath.isEmpty) {
      return;
    }

    final CowImage oldPhoto = record.images[index];
    await _deleteEmbeddingsLinkedToPhoto(
      cowId,
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
        where: 'cow_id = ? AND path = ?',
        whereArgs: <Object?>[cowId, oldPhoto.path],
      );
      final int newImageId = await _db!.insert('images', <String, Object?>{
        'cow_id': cowId,
        'path': savedPath,
        'uploaded_at': uploadedAt.toIso8601String(),
      });
      record.images[index] = CowImage(
        id: newImageId,
        path: savedPath,
        uploadedAt: uploadedAt,
      );
    }

    if (imageId != null) {
      record.images[index] = CowImage(
        id: imageId,
        path: savedPath,
        uploadedAt: uploadedAt,
      );
    }

    if (record.profileImagePath == oldPhoto.path) {
      record.profileImagePath = savedPath;
    }

    await _db!.update(
      'cows',
      <String, Object?>{'profile_image_path': record.profileImagePath},
      where: 'id = ?',
      whereArgs: <Object?>[cowId],
    );

    final List<double> normalized = normalizeEmbedding(embedding);
    final int? linkedImageId = record.images[index].id;
    final int embeddingId = await _db!.insert('embeddings', <String, Object?>{
      'cow_id': cowId,
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

  Future<void> deleteImage(String cowId, int index) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.images.length) {
      return;
    }

    final CowImage removed = record.images[index];
    await _deleteEmbeddingsLinkedToPhoto(
      cowId,
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
        where: 'cow_id = ? AND path = ?',
        whereArgs: <Object?>[cowId, removed.path],
      );
    }

    if (record.profileImagePath == removed.path) {
      record.profileImagePath = record.images.isNotEmpty
          ? record.images.first.path
          : null;
    }

    await _db!.update(
      'cows',
      <String, Object?>{'profile_image_path': record.profileImagePath},
      where: 'id = ?',
      whereArgs: <Object?>[cowId],
    );

    if (File(removed.path).existsSync()) {
      await File(removed.path).delete();
    }
  }

  // ---------------------------------------------------------------------------
  // Cow-level updates
  // ---------------------------------------------------------------------------

  Future<void> updateCowBasicInfo({
    required String oldCowId,
    required String newCowId,
    String? profileImagePath,
  }) async {
    final CowRecord? existing = _recordsByCow[oldCowId];
    if (existing == null) {
      return;
    }
    if (newCowId.trim().isEmpty) {
      return;
    }

    final String trimmedId = newCowId.trim();
    final CowRecord updated = CowRecord(
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
    );

    final Database db = _db!;
    await db.transaction((Transaction txn) async {
      // Insert the new cow row first.
      await txn.insert(
        'cows',
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
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Re-point all child rows from old cow id to new cow id.
      for (final String table in <String>[
        'embeddings',
        'health_records',
        'vaccinations',
        'notes',
        'images',
      ]) {
        await txn.update(
          table,
          <String, Object?>{'cow_id': trimmedId},
          where: 'cow_id = ?',
          whereArgs: <Object?>[oldCowId],
        );
      }

      // Delete old cow row (if the id actually changed).
      if (oldCowId != trimmedId) {
        await txn.delete(
          'cows',
          where: 'id = ?',
          whereArgs: <Object?>[oldCowId],
        );
      }
    });

    _recordsByCow.remove(oldCowId);
    _recordsByCow[trimmedId] = updated;
  }

  // ---------------------------------------------------------------------------
  // Breed Classification
  // ---------------------------------------------------------------------------

  /// Saves the breed classification result for [cowId] in memory and in SQLite.
  ///
  /// Calling this always resets any prior user confirmation so the user can
  /// review the new result and re-confirm if they wish.
  Future<void> saveBreedResult({
    required String cowId,
    required String breedName,
    required double breedConfidence,
    required List<BreedPrediction> alternatives,
  }) async {
    final CowRecord? record = _recordsByCow[cowId];
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
      'cows',
      <String, Object?>{
        'breed_name': breedName,
        'breed_confidence': breedConfidence,
        'breed_alternatives_json': alternativesJson,
        'confirmed_breed': null,
        'breed_confirmed_by_user': 0,
      },
      where: 'id = ?',
      whereArgs: <Object?>[cowId],
    );
  }

  /// Saves the user-chosen breed override for [cowId].
  ///
  /// This does NOT clear the model prediction — both can coexist.
  Future<void> confirmBreed({
    required String cowId,
    required String confirmedBreed,
  }) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null) {
      return;
    }

    record.confirmedBreed = confirmedBreed;
    record.breedConfirmedByUser = true;

    await _db!.update(
      'cows',
      <String, Object?>{
        'confirmed_breed': confirmedBreed,
        'breed_confirmed_by_user': 1,
      },
      where: 'id = ?',
      whereArgs: <Object?>[cowId],
    );
  }

  Future<void> deleteCow(String cowId) async {
    _recordsByCow.remove(cowId);

    final Database db = _db!;
    await db.transaction((Transaction txn) async {
      for (final String table in <String>[
        'embeddings',
        'health_records',
        'vaccinations',
        'notes',
        'images',
      ]) {
        await txn.delete(table, where: 'cow_id = ?', whereArgs: <Object?>[cowId]);
      }
      await txn.delete('cows', where: 'id = ?', whereArgs: <Object?>[cowId]);
    });
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Replaces all child rows for a given cow in the specified table.
  /// Used for update/delete operations on ordered lists where we don't have
  /// stable row IDs mapped to in-memory indices.
  Future<void> _replaceChildRows({
    required String cowId,
    required String table,
    required List<Map<String, Object?>> rows,
  }) async {
    final Database db = _db!;
    await db.transaction((Transaction txn) async {
      await txn.delete(table, where: 'cow_id = ?', whereArgs: <Object?>[cowId]);
      for (final Map<String, Object?> row in rows) {
        await txn.insert(table, row);
      }
    });
  }

  void _repairImagePaths() {
    for (final CowRecord record in _recordsByCow.values) {
      record.images.removeWhere(
        (CowImage image) => !File(image.path).existsSync(),
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
    for (final CowRecord record in _recordsByCow.values) {
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
    for (final CowRecord record in _recordsByCow.values) {
      final Set<String> pathsWithEmbedding = record.embeddings
          .map((EmbeddingReference ref) => ref.sourceImagePath)
          .whereType<String>()
          .where((String path) => path.isNotEmpty)
          .toSet();

      final List<CowImage> photosNeedingLink = record.images
          .where((CowImage img) => !pathsWithEmbedding.contains(img.path))
          .toList()
        ..sort(
          (CowImage a, CowImage b) => (a.id ?? 0).compareTo(b.id ?? 0),
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
        final CowImage photo = photosNeedingLink[index];
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
    for (final CowRecord record in _recordsByCow.values) {
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
    CowRecord record,
    EmbeddingReference ref,
  ) {
    if (ref.imageId != null &&
        record.images.any((CowImage img) => img.id == ref.imageId)) {
      return true;
    }
    final String? path = ref.sourceImagePath;
    if (path != null &&
        path.isNotEmpty &&
        record.images.any((CowImage img) => img.path == path)) {
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
        'cow_${DateTime.now().microsecondsSinceEpoch}$extension';
    final String targetPath = p.join(imageDir.path, fileName);
    await source.copy(targetPath);
    return targetPath;
  }
}
