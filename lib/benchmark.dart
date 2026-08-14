// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'models/benchmark_result.dart';
import 'services/benchmark_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Guard: run only in release mode
  const bool isRelease = bool.fromEnvironment('dart.vm.product');
  if (!isRelease) {
    print('WARNING: Benchmark should be run in release mode only for accurate results.');
    print('Run with: flutter run -t lib/benchmark.dart --release --dart-define=MODEL=MobileNetV2');
  }

  const String modelEnv = String.fromEnvironment('MODEL');
  const String runIdEnv = String.fromEnvironment('RUN_ID', defaultValue: 'default');

  if (modelEnv != 'MobileNetV2' && modelEnv != 'EfficientNet-B0') {
    print('\n========================================================================');
    print('ERROR: Please specify the model to benchmark using --dart-define=MODEL=<Name>');
    print('========================================================================');
    print('To benchmark MobileNetV2 in a clean process:');
    print('  flutter run -t lib/benchmark.dart --release --dart-define=MODEL=MobileNetV2');
    print('\nTo benchmark EfficientNet-B0 in a clean process:');
    print('  flutter run -t lib/benchmark.dart --release --dart-define=MODEL=EfficientNet-B0');
    print('\nYou can optionally add a run identifier via --dart-define=RUN_ID=<id>:');
    print('  flutter run -t lib/benchmark.dart --release --dart-define=MODEL=MobileNetV2 --dart-define=RUN_ID=run_1');
    print('========================================================================\n');
    exit(1);
  }

  final BenchmarkService svc = BenchmarkService();
  
  print('--- Starting Benchmark (MODEL: $modelEnv, RUN_ID: $runIdEnv) ---');
  
  final BenchmarkResult result;
  if (modelEnv == 'MobileNetV2') {
    print('Testing MobileNetV2 embedding model...');
    result = await svc.runEmbeddingBenchmark();
  } else {
    print('Testing EfficientNet-B0 breed verification model...');
    result = await svc.runBreedBenchmark();
  }
  
  print('Gathering device info...');
  final deviceInfo = await svc.getDeviceInfo();

  final results = {
    'runId': runIdEnv,
    'timestamp': DateTime.now().toUtc().toIso8601String(),
    'device': deviceInfo,
    'model': result.toJson(),
  };

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/benchmark_${modelEnv}_${runIdEnv}_${DateTime.now().millisecondsSinceEpoch}.json');
  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(results));
  
  print('\n=== BENCHMARK RESULT ===');
  print(const JsonEncoder.withIndent('  ').convert(results));
  print('=========================');
  print('Benchmark results successfully written to:');
  print(file.path);
  
  exit(0);
}
