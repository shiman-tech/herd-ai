/// A single breed prediction returned by [TfliteBreedService].
class BreedPrediction {
  const BreedPrediction({required this.name, required this.confidence});

  /// Display name of the breed (e.g. "Gir", "Sahiwal").
  final String name;

  /// Softmax probability in the range [0.0, 1.0].
  final double confidence;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'confidence': confidence,
  };

  factory BreedPrediction.fromJson(Map<String, dynamic> json) =>
      BreedPrediction(
        name: json['name'] as String? ?? '',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      );
}
