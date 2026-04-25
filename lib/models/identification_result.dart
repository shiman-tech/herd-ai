class IdentificationResult {
  const IdentificationResult({
    required this.predictedCowId,
    required this.similarity,
    required this.isKnown,
  });

  final String predictedCowId;
  final double similarity;
  final bool isKnown;
}
