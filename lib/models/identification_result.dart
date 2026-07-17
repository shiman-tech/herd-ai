class IdentificationResult {
  const IdentificationResult({
    required this.predictedCowId,
    required this.similarity,
    required this.isKnown,
    this.suggestedCowId,
  });

  final String predictedCowId;
  final double similarity;
  final bool isKnown;

  /// Best-matching registered cow when [isKnown] is false but a partial match
  /// exists. Used to surface borderline matches on the Identify tab.
  final String? suggestedCowId;

  bool get hasBorderlineMatch =>
      !isKnown &&
      suggestedCowId != null &&
      similarity >= IdentificationResult.borderlineThreshold;

  static const double borderlineThreshold = 0.55;
}
