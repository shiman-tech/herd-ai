import 'dart:math' as math;

double l2Norm(List<double> values) {
  double sum = 0;
  for (final double value in values) {
    sum += value * value;
  }
  return math.sqrt(sum);
}

List<double> normalizeEmbedding(List<double> embedding) {
  final double norm = l2Norm(embedding);
  if (norm == 0) {
    return List<double>.from(embedding);
  }
  return embedding.map((double value) => value / norm).toList();
}

double cosineSimilarity(List<double> a, List<double> b) {
  if (a.length != b.length || a.isEmpty) {
    return 0;
  }

  double dot = 0;
  double normA = 0;
  double normB = 0;

  for (int index = 0; index < a.length; index++) {
    dot += a[index] * b[index];
    normA += a[index] * a[index];
    normB += b[index] * b[index];
  }

  if (normA == 0 || normB == 0) {
    return 0;
  }

  return dot / (math.sqrt(normA) * math.sqrt(normB));
}
