import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'models/identification_result.dart';
import 'services/embedding_database.dart';
import 'services/tflite_embedding_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HerdAiApp());
}

class HerdAiApp extends StatelessWidget {
  const HerdAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Herd AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D6A4F)),
        scaffoldBackgroundColor: const Color(0xFFF7F7F4),
        useMaterial3: true,
      ),
      home: const HerdHomePage(),
    );
  }
}

class HerdHomePage extends StatefulWidget {
  const HerdHomePage({super.key});

  @override
  State<HerdHomePage> createState() => _HerdHomePageState();
}

class _HerdHomePageState extends State<HerdHomePage> {
  final ImagePicker _picker = ImagePicker();
  final TfliteEmbeddingService _embeddingService = TfliteEmbeddingService();
  final EmbeddingDatabase _database = EmbeddingDatabase();
  final TextEditingController _cowIdController = TextEditingController();

  File? _selectedImage;
  bool _isBusy = false;
  bool _isReady = false;
  String? _initializationError;
  String? _statusMessage;
  String? _modelInfo;
  IdentificationResult? _result;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _isBusy = true;
      _isReady = false;
      _initializationError = null;
      _statusMessage = 'Loading model and local database...';
    });

    try {
      await _embeddingService.loadModel();
      await _database.load();
      setState(() {
        _isReady = true;
        _modelInfo = _embeddingService.describeModel();
        _statusMessage = _database.isEmpty
            ? 'Ready. The database is empty, so the first cow will be predicted as Unknown until you register it.'
            : 'Ready for offline identification.';
      });
    } catch (error) {
      setState(() {
        _initializationError = error.toString();
        _statusMessage = _initializationError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cowIdController.dispose();
    _embeddingService.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 95,
      maxWidth: 1600,
    );

    if (image == null) {
      return;
    }

    setState(() {
      _selectedImage = File(image.path);
      _result = null;
      _statusMessage = _isReady
          ? 'Image selected. Tap "Identify Cow" to run inference.'
          : (_initializationError ??
                'Model is not loaded yet. Fix initialization before inference.');
    });
  }

  Future<void> _identifyCow() async {
    if (!_isReady || _selectedImage == null) {
      setState(() {
        _statusMessage = 'Select an image after the model finishes loading.';
      });
      return;
    }

    setState(() {
      _isBusy = true;
      _statusMessage =
          'Generating embedding and comparing with local records...';
    });

    try {
      final IdentificationResult result = await _database.predictCow(
        _selectedImage!,
        embeddingService: _embeddingService,
      );

      setState(() {
        _result = result;
        _statusMessage = result.isKnown
            ? 'Identification completed successfully.'
            : _database.isEmpty
            ? 'Database is empty. Register this cow to start building the local memory.'
            : 'No stored embedding passed the similarity threshold.';
      });
    } catch (error) {
      setState(() {
        _statusMessage = 'Identification failed: $error';
      });
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  Future<void> _registerCow() async {
    final String cowId = _cowIdController.text.trim();
    if (!_isReady || _selectedImage == null) {
      setState(() {
        _statusMessage = 'Select an image before registering a cow.';
      });
      return;
    }
    if (cowId.isEmpty) {
      setState(() {
        _statusMessage = 'Enter a cow ID to save the embedding.';
      });
      return;
    }

    setState(() {
      _isBusy = true;
      _statusMessage = 'Extracting embedding and saving it locally...';
    });

    try {
      final List<double> embedding = await _embeddingService.getEmbedding(
        _selectedImage!,
      );
      await _database.registerCow(cowId: cowId, embedding: embedding);
      _cowIdController.clear();
      setState(() {
        _statusMessage =
            'Saved embedding for "$cowId". Future images can now match against it.';
      });
    } catch (error) {
      setState(() {
        _statusMessage = 'Registration failed: $error';
      });
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Livestock Identifier')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _HeaderCard(
                modelInfo: _modelInfo,
                statusMessage: _statusMessage,
                databaseCount: _database.totalEmbeddings,
                cowCount: _database.totalCows,
                isReady: _isReady,
                initializationError: _initializationError,
                onRetry: _isBusy ? null : _initialize,
              ),
              const SizedBox(height: 16),
              _ImagePreviewCard(imageFile: _selectedImage),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _isBusy
                        ? null
                        : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Capture Image'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _isBusy
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Upload Image'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: (_isBusy || !_isReady) ? null : _identifyCow,
                    icon: const Icon(Icons.search),
                    label: const Text('Identify Cow'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Prediction', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              _PredictionCard(result: _result),
              const SizedBox(height: 24),
              Text('Register New Cow', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _cowIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cow ID',
                  hintText: 'e.g. Cow_014',
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: (_isBusy || !_isReady) ? null : _registerCow,
                icon: const Icon(Icons.save_alt_outlined),
                label: const Text('Register New Cow'),
              ),
              const SizedBox(height: 16),
              Text(
                'Threshold: ${_database.similarityThreshold.toStringAsFixed(2)}'
                ' cosine similarity',
                style: theme.textTheme.bodySmall,
              ),
              if (_isBusy) ...<Widget>[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.modelInfo,
    required this.statusMessage,
    required this.databaseCount,
    required this.cowCount,
    required this.isReady,
    required this.initializationError,
    required this.onRetry,
  });

  final String? modelInfo;
  final String? statusMessage;
  final int databaseCount;
  final int cowCount;
  final bool isReady;
  final String? initializationError;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    final Color accent = isReady
        ? const Color(0xFF2D6A4F)
        : Colors.orange.shade700;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'On-device pipeline',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Image -> TFLite embedding -> cosine similarity -> prediction',
            ),
            const SizedBox(height: 12),
            Text(
              modelInfo ??
                  'Expected model: assets/models/cow_identifier.tflite',
              style: TextStyle(color: accent),
            ),
            const SizedBox(height: 8),
            const Text(
              'This app does not classify fixed identities. It only creates embeddings and compares them with the local database.',
            ),
            const SizedBox(height: 8),
            Text('Registered cows: $cowCount'),
            Text('Stored embeddings: $databaseCount'),
            if (initializationError != null) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                initializationError!,
                style: TextStyle(color: Colors.red.shade700),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry model initialization'),
              ),
            ],
            if (statusMessage != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(statusMessage!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImagePreviewCard extends StatelessWidget {
  const _ImagePreviewCard({required this.imageFile});

  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 260,
        child: imageFile == null
            ? const Center(child: Text('No image selected'))
            : Image.file(imageFile!, fit: BoxFit.cover),
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({required this.result});

  final IdentificationResult? result;

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Run identification to view the prediction.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              result!.predictedCowId,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Similarity: ${result!.similarity.toStringAsFixed(4)}'),
            const SizedBox(height: 4),
            Text(
              result!.isKnown
                  ? 'Matched local embedding database.'
                  : 'No close embedding found, so this image is treated as unknown.',
            ),
          ],
        ),
      ),
    );
  }
}
