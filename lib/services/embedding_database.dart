import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cow_record.dart';
import '../models/identification_result.dart';
import '../utils/math_utils.dart';
import 'tflite_embedding_service.dart';

class EmbeddingDatabase {
  static const String _dbFileName = 'herd_ai.db';
  static const String _legacyJsonFileName = 'cow_records.json';
  static const String _imageDirName = 'cow_images';
  static const int _dbVersion = 1;

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
    );
  }

  Future<void> _createTables(Database db) async {
    final Batch batch = db.batch();
    batch.execute('''
      CREATE TABLE IF NOT EXISTS cows (
        id TEXT PRIMARY KEY,
        registration_date TEXT NOT NULL,
        profile_image_path TEXT
      )
    ''');
    batch.execute('''
      CREATE TABLE IF NOT EXISTS embeddings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cow_id TEXT NOT NULL,
        vector TEXT NOT NULL,
        FOREIGN KEY (cow_id) REFERENCES cows(id) ON DELETE CASCADE
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

        for (final List<double> embedding in cow.embeddings) {
          await txn.insert('embeddings', <String, Object?>{
            'cow_id': cow.id,
            'vector': jsonEncode(embedding),
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

        for (final String imagePath in cow.images) {
          await txn.insert('images', <String, Object?>{
            'cow_id': cow.id,
            'path': imagePath,
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
      final List<List<double>> embeddings = (entry.value as List<dynamic>)
          .map(
            (dynamic row) => (row as List<dynamic>)
                .map((dynamic value) => (value as num).toDouble())
                .toList(),
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
      _recordsByCow[cowId] = CowRecord(
        id: cowId,
        registrationDate: DateTime.tryParse(
              row['registration_date'] as String? ?? '',
            ) ??
            DateTime.now(),
        profileImagePath: row['profile_image_path'] as String?,
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
      record.embeddings.add(vector);
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
      record.images.add(row['path']! as String);
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

    // Insert embedding.
    record.embeddings.add(normalized);
    await db.insert('embeddings', <String, Object?>{
      'cow_id': cowId,
      'vector': jsonEncode(normalized),
    });

    // Handle image.
    if (imagePath != null && imagePath.isNotEmpty) {
      final String savedPath = await _persistImage(imagePath);
      record.profileImagePath ??= savedPath;
      record.images.add(savedPath);
      await db.insert('images', <String, Object?>{
        'cow_id': cowId,
        'path': savedPath,
      });
      await db.update(
        'cows',
        <String, Object?>{'profile_image_path': record.profileImagePath},
        where: 'id = ?',
        whereArgs: <Object?>[cowId],
      );
    }

    // Handle note.
    if (note != null && note.trim().isNotEmpty) {
      record.notes.add(note.trim());
      await db.insert('notes', <String, Object?>{
        'cow_id': cowId,
        'content': note.trim(),
      });
    }
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
      for (final List<double> storedEmbedding in record.embeddings) {
        final double score = cosineSimilarity(queryEmbedding, storedEmbedding);
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

  Future<void> addImage(String cowId, String imagePath) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || imagePath.isEmpty) {
      return;
    }
    final String savedPath = await _persistImage(imagePath);
    record.profileImagePath ??= savedPath;
    record.images.add(savedPath);
    await _db!.insert('images', <String, Object?>{
      'cow_id': cowId,
      'path': savedPath,
    });
    await _db!.update(
      'cows',
      <String, Object?>{'profile_image_path': record.profileImagePath},
      where: 'id = ?',
      whereArgs: <Object?>[cowId],
    );
  }

  Future<void> updateImage({
    required String cowId,
    required int index,
    required String imagePath,
  }) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null ||
        index < 0 ||
        index >= record.images.length ||
        imagePath.isEmpty) {
      return;
    }
    final String savedPath = await _persistImage(imagePath);
    record.images[index] = savedPath;
    record.profileImagePath ??= savedPath;
    await _replaceChildRows(
      cowId: cowId,
      table: 'images',
      rows: record.images
          .map((String path) => <String, Object?>{
                'cow_id': cowId,
                'path': path,
              })
          .toList(),
    );
    await _db!.update(
      'cows',
      <String, Object?>{'profile_image_path': record.profileImagePath},
      where: 'id = ?',
      whereArgs: <Object?>[cowId],
    );
  }

  Future<void> deleteImage(String cowId, int index) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.images.length) {
      return;
    }
    final String removed = record.images.removeAt(index);
    if (record.profileImagePath == removed) {
      record.profileImagePath = record.images.isNotEmpty
          ? record.images.first
          : null;
    }
    await _replaceChildRows(
      cowId: cowId,
      table: 'images',
      rows: record.images
          .map((String path) => <String, Object?>{
                'cow_id': cowId,
                'path': path,
              })
          .toList(),
    );
    await _db!.update(
      'cows',
      <String, Object?>{'profile_image_path': record.profileImagePath},
      where: 'id = ?',
      whereArgs: <Object?>[cowId],
    );
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
      record.images.removeWhere((String path) => !File(path).existsSync());
      if (record.profileImagePath != null &&
          !File(record.profileImagePath!).existsSync()) {
        record.profileImagePath = null;
      }
      if (record.profileImagePath == null && record.images.isNotEmpty) {
        record.profileImagePath = record.images.first;
      }
    }
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
