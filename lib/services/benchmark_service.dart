import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/benchmark_result.dart';

class BenchmarkService {
  static const MethodChannel _channel = MethodChannel('benchmark_channel');

  Future<Map<String, dynamic>> getDeviceInfo() async {
    final Map<Object?, Object?>? result = await _channel.invokeMethod<Map<Object?, Object?>>('getDeviceInfo');
    return result?.cast<String, dynamic>() ?? {};
  }

  Future<double> getPss() async {
    final double? pss = await _channel.invokeMethod<double>('getPss');
    return pss ?? 0.0;
  }

  Future<double> getModelSize(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.lengthInBytes / (1024 * 1024);
  }

  Future<InferenceStats> benchmarkInference(Interpreter interpreter) async {
    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;
    
    // Create dummy input
    final input = _createDummyTensor(inputShape);
    final output = _createDummyTensor(outputShape);

    // Warm-up
    for (int i = 0; i < 10; i++) {
      interpreter.run(input, output);
    }

    // Benchmark
    final List<int> times = [];
    for (int i = 0; i < 100; i++) {
      final watch = Stopwatch()..start();
      interpreter.run(input, output);
      watch.stop();
      times.add(watch.elapsedMicroseconds);
    }

    final double avgMs = times.reduce((a, b) => a + b) / times.length / 1000.0;
    final double minMs = times.reduce(math.min) / 1000.0;
    final double maxMs = times.reduce(math.max) / 1000.0;
    
    double variance = 0;
    for (final time in times) {
      final double diff = (time / 1000.0) - avgMs;
      variance += diff * diff;
    }
    final double stdDevMs = math.sqrt(variance / times.length);

    return InferenceStats(
      avgMs: double.parse(avgMs.toStringAsFixed(2)),
      minMs: double.parse(minMs.toStringAsFixed(2)),
      maxMs: double.parse(maxMs.toStringAsFixed(2)),
      stdDevMs: double.parse(stdDevMs.toStringAsFixed(2)),
    );
  }

  dynamic _createDummyTensor(List<int> shape) {
    if (shape.length == 2) {
      return List.generate(shape[0], (_) => List.generate(shape[1], (_) => 0.0));
    } else if (shape.length == 4) {
      return List.generate(shape[0], (_) => List.generate(shape[1], (_) => List.generate(shape[2], (_) => List.generate(shape[3], (_) => 0.0))));
    }
    throw UnsupportedError('Only 2D and 4D tensors supported by benchmark dummy data');
  }

  Future<BenchmarkResult> runBenchmark(String modelName, String assetPath) async {
    final double sizeMb = await getModelSize(assetPath);

    // Trigger GC to clear out any stale objects before baseline PSS measurement
    await _channel.invokeMethod<void>('gc');
    final double pssBefore = await getPss();

    final loadWatch = Stopwatch()..start();
    final Interpreter interpreter = await Interpreter.fromAsset(assetPath);
    loadWatch.stop();

    final double pssAfter = await getPss();

    // Warm-up
    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;
    final input = _createDummyTensor(inputShape);
    final output = _createDummyTensor(outputShape);

    for (int i = 0; i < 10; i++) {
      interpreter.run(input, output);
    }

    // Benchmark & PSS Peak Sampling
    final List<int> times = [];
    double peakPss = pssAfter;
    for (int i = 0; i < 100; i++) {
      final watch = Stopwatch()..start();
      interpreter.run(input, output);
      watch.stop();
      times.add(watch.elapsedMicroseconds);

      // Query PSS outside of the timed block to prevent benchmark overhead
      final double currentPss = await getPss();
      if (currentPss > peakPss) {
        peakPss = currentPss;
      }
    }

    final double avgMs = times.reduce((a, b) => a + b) / times.length / 1000.0;
    final double minMs = times.reduce(math.min) / 1000.0;
    final double maxMs = times.reduce(math.max) / 1000.0;
    
    double variance = 0;
    for (final time in times) {
      final double diff = (time / 1000.0) - avgMs;
      variance += diff * diff;
    }
    final double stdDevMs = math.sqrt(variance / times.length);

    final InferenceStats stats = InferenceStats(
      avgMs: double.parse(avgMs.toStringAsFixed(2)),
      minMs: double.parse(minMs.toStringAsFixed(2)),
      maxMs: double.parse(maxMs.toStringAsFixed(2)),
      stdDevMs: double.parse(stdDevMs.toStringAsFixed(2)),
    );

    interpreter.close();

    final double additionalMem = pssAfter - pssBefore;

    return BenchmarkResult(
      modelName: modelName,
      tfliteSizeMb: double.parse(sizeMb.toStringAsFixed(2)),
      loadTimeMs: loadWatch.elapsedMilliseconds,
      inferenceStats: stats,
      pssBeforeLoadMb: double.parse(pssBefore.toStringAsFixed(2)),
      pssAfterLoadMb: double.parse(pssAfter.toStringAsFixed(2)),
      additionalProcessMemoryMb: double.parse((additionalMem > 0 ? additionalMem : 0.0).toStringAsFixed(2)),
      peakProcessPssMb: double.parse(peakPss.toStringAsFixed(2)),
    );
  }

  Future<BenchmarkResult> runEmbeddingBenchmark() async {
    return runBenchmark('MobileNetV2', 'assets/models/cow_identifier.tflite');
  }

  Future<BenchmarkResult> runBreedBenchmark() async {
    return runBenchmark('EfficientNet-B0', 'assets/models/efficientnet_breed_classifier.tflite');
  }
}
