import 'package:flutter_test/flutter_test.dart';
import 'package:herd_ai/utils/math_utils.dart';

void main() {
  test('cosine similarity is 1.0 for identical vectors', () {
    final double score = cosineSimilarity(<double>[1, 2, 3], <double>[1, 2, 3]);

    expect(score, closeTo(1.0, 0.0001));
  });

  test('normalizeEmbedding returns unit-length vectors', () {
    final List<double> normalized = normalizeEmbedding(<double>[3, 4]);

    expect(l2Norm(normalized), closeTo(1.0, 0.0001));
  });
}
