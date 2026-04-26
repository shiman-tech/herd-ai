import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/cow_record.dart';
import '../models/identification_result.dart';
import '../utils/math_utils.dart';
import 'tflite_embedding_service.dart';

class EmbeddingDatabase {
  static const String _localFileName = 'cow_records.json';

  final Map<String, CowRecord> _recordsByCow = <String, CowRecord>{};

  final double similarityThreshold;

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

  Future<void> load() async {
    final File localFile = await _getLocalFile();
    if (await localFile.exists()) {
      final String content = await localFile.readAsString();
      _decodeIntoMemory(content);
      return;
    }

    await _persist();
  }

  Future<void> registerCow({
    required String cowId,
    required List<double> embedding,
    String? imagePath,
    String? note,
  }) async {
    final List<double> normalized = normalizeEmbedding(embedding);
    final CowRecord record = _recordsByCow.putIfAbsent(
      cowId,
      () => CowRecord(id: cowId, registrationDate: DateTime.now()),
    );
    record.embeddings.add(normalized);
    if (imagePath != null && imagePath.isNotEmpty) {
      record.profileImagePath ??= imagePath;
      record.images.add(imagePath);
    }
    if (note != null && note.trim().isNotEmpty) {
      record.notes.add(note.trim());
    }
    await _persist();
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

  Future<void> addHealthRecord(String cowId, HealthRecord healthRecord) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null) {
      return;
    }
    record.healthRecords.add(healthRecord);
    await _persist();
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
    await _persist();
  }

  Future<void> deleteHealthRecord(String cowId, int index) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.healthRecords.length) {
      return;
    }
    record.healthRecords.removeAt(index);
    await _persist();
  }

  Future<void> addVaccinationRecord(
    String cowId,
    VaccinationRecord vaccinationRecord,
  ) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null) {
      return;
    }
    record.vaccinations.add(vaccinationRecord);
    await _persist();
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
    await _persist();
  }

  Future<void> deleteVaccinationRecord(String cowId, int index) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.vaccinations.length) {
      return;
    }
    record.vaccinations.removeAt(index);
    await _persist();
  }

  Future<void> addNote(String cowId, String note) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || note.trim().isEmpty) {
      return;
    }
    record.notes.add(note.trim());
    await _persist();
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
    await _persist();
  }

  Future<void> deleteNote(String cowId, int index) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || index < 0 || index >= record.notes.length) {
      return;
    }
    record.notes.removeAt(index);
    await _persist();
  }

  Future<void> addImage(String cowId, String imagePath) async {
    final CowRecord? record = _recordsByCow[cowId];
    if (record == null || imagePath.isEmpty) {
      return;
    }
    record.profileImagePath ??= imagePath;
    record.images.add(imagePath);
    await _persist();
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
    record.images[index] = imagePath;
    record.profileImagePath ??= imagePath;
    await _persist();
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
    await _persist();
  }

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

    final CowRecord updated = CowRecord(
      id: newCowId.trim(),
      registrationDate: existing.registrationDate,
      profileImagePath: profileImagePath ?? existing.profileImagePath,
      embeddings: existing.embeddings,
      healthRecords: existing.healthRecords,
      vaccinations: existing.vaccinations,
      notes: existing.notes,
      images: existing.images,
    );
    _recordsByCow.remove(oldCowId);
    _recordsByCow[updated.id] = updated;
    await _persist();
  }

  Future<void> deleteCow(String cowId) async {
    _recordsByCow.remove(cowId);
    await _persist();
  }

  void _decodeIntoMemory(String content) {
    _recordsByCow.clear();
    if (content.trim().isEmpty) {
      return;
    }

    final dynamic decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      return;
    }

    if (decoded['records'] is Map<String, dynamic>) {
      final Map<String, dynamic> records =
          decoded['records'] as Map<String, dynamic>;
      for (final MapEntry<String, dynamic> entry in records.entries) {
        _recordsByCow[entry.key] = CowRecord.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
      return;
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
      _recordsByCow[entry.key] = CowRecord(
        id: entry.key,
        registrationDate: DateTime.now(),
        embeddings: embeddings,
      );
    }
  }

  Future<void> _persist() async {
    final File file = await _getLocalFile();
    final Map<String, dynamic> payload = <String, dynamic>{
      'records': <String, dynamic>{
        for (final MapEntry<String, CowRecord> entry in _recordsByCow.entries)
          entry.key: entry.value.toJson(),
      },
    };
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload),
    );
  }

  Future<File> _getLocalFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}${Platform.pathSeparator}$_localFileName');
  }
}
