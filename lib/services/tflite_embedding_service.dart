import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../utils/math_utils.dart';

class TfliteEmbeddingService {
  static const List<String> _candidateModelAssetPaths = <String>[
    'assets/models/cow_identifier.tflite',
    'models/cow_identifier.tflite',
  ];
  static const int inputSize = 224;
  static const int embeddingSize = 128;

  Interpreter? _interpreter;
  List<int>? _inputShape;
  List<int>? _outputShape;
  String? _loadedModelAssetPath;

  Future<void> loadModel() async {
    Exception? lastError;

    for (final String candidatePath in _candidateModelAssetPaths) {
      try {
        _interpreter = await Interpreter.fromAsset(candidatePath);
        _loadedModelAssetPath = candidatePath;
        _inputShape = _interpreter!.getInputTensor(0).shape;
        _outputShape = _interpreter!.getOutputTensor(0).shape;
        _validateModelTensors();
        return;
      } catch (error) {
        lastError = Exception('Failed to load "$candidatePath": $error');
      }
    }

    throw Exception(
      'Unable to load TFLite model. Put the file at either '
      '"assets/models/cow_identifier.tflite" or "models/cow_identifier.tflite", '
      'then restart the app. '
      '${_platformHint()} '
      'Last error: ${lastError ?? "unknown"}',
    );
  }

  String _platformHint() {
    if (Platform.isWindows) {
      return 'On Windows desktop, tflite_flutter also requires '
          'blobs/libtensorflowlite_c-win.dll to be bundled.';
    }
    if (Platform.isLinux) {
      return 'On Linux desktop, tflite_flutter also requires a TensorFlow Lite '
          'shared library (.so) bundled with the app.';
    }
    if (Platform.isMacOS) {
      return 'On macOS desktop, tflite_flutter also requires a TensorFlow Lite '
          'dynamic library (.dylib) bundled with the app.';
    }
    return '';
  }

  void _validateModelTensors() {
    final List<int> input = _inputShape ?? <int>[];
    final List<int> output = _outputShape ?? <int>[];

    if (input.length != 4 ||
        input[0] != 1 ||
        input[1] != inputSize ||
        input[2] != inputSize ||
        input[3] != 3) {
      throw Exception(
        'Unexpected input tensor shape: $input. Expected [1, 224, 224, 3].',
      );
    }

    if (output.length != 2 || output[0] != 1 || output[1] != embeddingSize) {
      throw Exception(
        'Unexpected output tensor shape: $output. Expected [1, 128].',
      );
    }
  }

  String describeModel() {
    final List<int> input = _inputShape ?? <int>[];
    final List<int> output = _outputShape ?? <int>[];
    return 'Model loaded from "${_loadedModelAssetPath ?? "unknown"}". '
        'Input: $input, Output: $output';
  }

  Future<List<double>> getEmbedding(File imageFile) async {
    final Interpreter interpreter =
        _interpreter ??
        (throw StateError('Call loadModel() before requesting embeddings.'));

    final Uint8List bytes = await imageFile.readAsBytes();
    final img.Image decoded =
        img.decodeImage(bytes) ??
        (throw Exception('Unable to decode selected image.'));
    final img.Image resized = img.copyResize(
      decoded,
      width: inputSize,
      height: inputSize,
      interpolation: img.Interpolation.linear,
    );

    final List<List<List<List<double>>>> input = <List<List<List<double>>>>[
      List<List<List<double>>>.generate(
        inputSize,
        (int y) => List<List<double>>.generate(inputSize, (int x) {
          final img.Pixel pixel = resized.getPixel(x, y);
          return <double>[pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    ];

    final List<List<double>> output = <List<double>>[
      List<double>.filled(embeddingSize, 0),
    ];

    interpreter.run(input, output);

    return normalizeEmbedding(output.first);
  }

  void dispose() {
    _interpreter?.close();
  }
}
