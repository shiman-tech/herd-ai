class InferenceStats {
  const InferenceStats({
    required this.avgMs,
    required this.minMs,
    required this.maxMs,
    required this.stdDevMs,
  });

  final double avgMs;
  final double minMs;
  final double maxMs;
  final double stdDevMs;

  Map<String, dynamic> toJson() => {
        'avgInferenceMs': avgMs,
        'minInferenceMs': minMs,
        'maxInferenceMs': maxMs,
        'stdDevMs': stdDevMs,
      };
}

class BenchmarkResult {
  const BenchmarkResult({
    required this.modelName,
    required this.tfliteSizeMb,
    required this.loadTimeMs,
    required this.inferenceStats,
    required this.pssBeforeLoadMb,
    required this.pssAfterLoadMb,
    required this.additionalProcessMemoryMb,
    required this.peakProcessPssMb,
  });

  final String modelName;
  final double tfliteSizeMb;
  final int loadTimeMs;
  final InferenceStats inferenceStats;
  final double pssBeforeLoadMb;
  final double pssAfterLoadMb;
  final double additionalProcessMemoryMb;
  final double peakProcessPssMb;

  Map<String, dynamic> toJson() => {
        'name': modelName,
        'tfliteSizeMb': tfliteSizeMb,
        'loadTimeMs': loadTimeMs,
        'pssBeforeLoadMb': pssBeforeLoadMb,
        'pssAfterLoadMb': pssAfterLoadMb,
        'additionalProcessMemoryMb': additionalProcessMemoryMb,
        'peakProcessPssMb': peakProcessPssMb,
        ...inferenceStats.toJson(),
      };
}
