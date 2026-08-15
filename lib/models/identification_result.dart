class IdentificationResult {
  const IdentificationResult({
    required this.predictedCattleId,
    required this.similarity,
    required this.isKnown,
    this.suggestedCattleId,
  });

  final String predictedCattleId;
  final double similarity;
  final bool isKnown;

  /// Best-matching registered cattle when [isKnown] is false but a partial match
  /// exists. Used to surface borderline matches on the Identify tab.
  final String? suggestedCattleId;

  bool get hasBorderlineMatch =>
      !isKnown &&
      suggestedCattleId != null &&
      similarity >= IdentificationResult.borderlineThreshold;

  static const double borderlineThreshold = 0.70;
}
