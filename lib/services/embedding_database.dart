import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/identification_result.dart';
import '../utils/math_utils.dart';
import 'tflite_embedding_service.dart';

class EmbeddingDatabase {
  static const String _localFileName = 'cow_embeddings.json';

  final Map<String, List<List<double>>> _embeddingsByCow =
      <String, List<List<double>>>{};

  final double similarityThreshold;

  EmbeddingDatabase({this.similarityThreshold = 0.75});

  int get totalEmbeddings => _embeddingsByCow.values.fold<int>(
    0,
    (int total, List<List<double>> embeddings) => total + embeddings.length,
  );

  int get totalCows => _embeddingsByCow.length;

  bool get isEmpty => _embeddingsByCow.isEmpty;

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
  }) async {
    final List<double> normalized = normalizeEmbedding(embedding);
    _embeddingsByCow.putIfAbsent(cowId, () => <List<double>>[]).add(normalized);
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

    for (final MapEntry<String, List<List<double>>> entry
        in _embeddingsByCow.entries) {
      for (final List<double> storedEmbedding in entry.value) {
        final double score = cosineSimilarity(queryEmbedding, storedEmbedding);
        if (score > bestScore) {
          bestScore = score;
          bestCowId = entry.key;
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

  void _decodeIntoMemory(String content) {
    _embeddingsByCow.clear();
    if (content.trim().isEmpty) {
      return;
    }

    final Map<String, dynamic> jsonMap =
        jsonDecode(content) as Map<String, dynamic>;
    for (final MapEntry<String, dynamic> entry in jsonMap.entries) {
      final List<dynamic> rawEmbeddings = entry.value as List<dynamic>;
      _embeddingsByCow[entry.key] = rawEmbeddings
          .map(
            (dynamic vector) => (vector as List<dynamic>)
                .map((dynamic value) => (value as num).toDouble())
                .toList(),
          )
          .toList();
    }
  }

  Future<void> _persist() async {
    final File file = await _getLocalFile();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(_embeddingsByCow),
    );
  }

  Future<File> _getLocalFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}${Platform.pathSeparator}$_localFileName');
  }
}
