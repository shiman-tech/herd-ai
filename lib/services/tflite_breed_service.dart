import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/breed_prediction.dart';

/// Isolated service that runs the EfficientNet breed-classification model.
///
/// Usage mirrors [TfliteEmbeddingService]: call [loadModel] once during app
/// startup, then call [classifyBreed] as needed, and [dispose] on teardown.
class TfliteBreedService {
  static const String _modelAssetPath =
      'assets/models/efficientnet_breed_classifier.tflite';
  static const String _classNamesAssetPath =
      'assets/models/class_names.json';
  static const int _inputSize = 224;

  /// Top-N predictions to return.
  static const int topN = 5;

  Interpreter? _interpreter;
  List<String> _classNames = <String>[];
  List<int>? _inputShape;
  List<int>? _outputShape;

  /// Loads the TFLite model and class names from assets.
  /// Must be called before [classifyBreed].
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(_modelAssetPath);
    _inputShape = _interpreter!.getInputTensor(0).shape;
    _outputShape = _interpreter!.getOutputTensor(0).shape;
    _validateTensors();

    // Load class names JSON: expected to be a JSON array of strings.
    final String rawJson = await rootBundle.loadString(_classNamesAssetPath);
    final dynamic decoded = jsonDecode(rawJson);
    if (decoded is List<dynamic>) {
      _classNames = decoded.map((dynamic e) => e.toString()).toList();
    } else if (decoded is Map<String, dynamic>) {
      // Support {0: "Gir", 1: "Sahiwal", ...} style maps
      final List<MapEntry<String, dynamic>> sorted =
          decoded.entries.toList()
            ..sort(
              (MapEntry<String, dynamic> a, MapEntry<String, dynamic> b) =>
                  int.parse(a.key).compareTo(int.parse(b.key)),
            );
      _classNames = sorted.map((MapEntry<String, dynamic> e) => e.value.toString()).toList();
    }

    if (_classNames.isEmpty) {
      throw Exception(
        'class_names.json is empty or in an unexpected format. '
        'Expected a JSON array of breed name strings.',
      );
    }
  }

  void _validateTensors() {
    final List<int> input = _inputShape ?? <int>[];
    if (input.length != 4 ||
        input[0] != 1 ||
        input[1] != _inputSize ||
        input[2] != _inputSize ||
        input[3] != 3) {
      throw Exception(
        'Unexpected breed model input shape: $input. '
        'Expected [1, $_inputSize, $_inputSize, 3].',
      );
    }
  }

  String describeModel() {
    return 'Breed model: input=$_inputShape, output=$_outputShape, '
        '${_classNames.length} classes';
  }

  /// Runs inference on [imageFile] and returns the top-[topN] breed
  /// predictions sorted by confidence descending.
  Future<List<BreedPrediction>> classifyBreed(File imageFile) async {
    final Interpreter interpreter =
        _interpreter ??
        (throw StateError('Call loadModel() before classifyBreed().'));

    if (_classNames.isEmpty) {
      throw StateError('Class names not loaded. Call loadModel() first.');
    }

    // Preprocess image: resize to 224×224, normalize to [0, 1].
    final Uint8List bytes = await imageFile.readAsBytes();
    final img.Image decoded =
        img.decodeImage(bytes) ??
        (throw Exception('Unable to decode image for breed classification.'));
    final img.Image resized = img.copyResize(
      decoded,
      width: _inputSize,
      height: _inputSize,
      interpolation: img.Interpolation.linear,
    );

    final List<List<List<List<double>>>> input =
        <List<List<List<double>>>>[
      List<List<List<double>>>.generate(
        _inputSize,
        (int y) => List<List<double>>.generate(_inputSize, (int x) {
          final img.Pixel pixel = resized.getPixel(x, y);
          return <double>[pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    ];

    final int numClasses = _outputShape?[1] ?? _classNames.length;
    final List<List<double>> output = <List<double>>[
      List<double>.filled(numClasses, 0),
    ];

    interpreter.run(input, output);

    // Model outputs softmax probabilities directly — no need to apply softmax.
    final List<double> probs = output.first;

    // Build predictions paired with class names.
    final List<BreedPrediction> predictions = <BreedPrediction>[];
    for (int i = 0; i < probs.length && i < _classNames.length; i++) {
      predictions.add(BreedPrediction(name: _classNames[i], confidence: probs[i]));
    }

    // Sort descending by confidence and take top-N.
    predictions.sort(
      (BreedPrediction a, BreedPrediction b) =>
          b.confidence.compareTo(a.confidence),
    );
    return predictions.take(topN).toList();
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
