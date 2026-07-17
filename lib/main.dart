import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'models/cow_record.dart';
import 'models/embedding_reference.dart';
import 'models/identification_result.dart';
import 'services/app_auth_service.dart';
import 'services/app_lock_controller.dart';
import 'services/embedding_database.dart';
import 'services/tflite_embedding_service.dart';
import 'widgets/auth_gate.dart';
import 'widgets/cow_detail_page.dart';

const Color kFarmPrimary = Color(0xFF2D6A4F);
const Color kFarmSecondary = Color(0xFF95A97F);
const Color kFarmBackground = Color(0xFFF4F1E6);
const Color kFarmAccent = Color(0xFF8D6E63);

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: kFarmPrimary,
          primary: kFarmPrimary,
          secondary: kFarmSecondary,
          surface: const Color(0xFFFBFAF4),
        ),
        scaffoldBackgroundColor: kFarmBackground,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: kFarmBackground,
          foregroundColor: kFarmPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: kFarmPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFEFA),
          elevation: 2.5,
          shadowColor: Color(0x14000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: kFarmPrimary,
            foregroundColor: Colors.white,
            minimumSize: const Size(140, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kFarmAccent,
            side: const BorderSide(color: kFarmAccent),
            minimumSize: const Size(140, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFEFA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDFDAC8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDFDAC8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kFarmPrimary, width: 1.5),
          ),
        ),
      ),
      home: const AuthGate(child: HerdHomePage()),
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
  final AppAuthService _appAuthService = AppAuthService();
  final EmbeddingDatabase _database = EmbeddingDatabase();
  final TextEditingController _searchController = TextEditingController();

  File? _selectedImage;
  int _currentTab = 0;
  bool _isBusy = false;
  bool _isReady = false;
  String? _initializationError;
  String? _statusMessage;
  IdentificationResult? _result;

  Widget _cowAvatar(String? imagePath) {
    if (imagePath == null || !File(imagePath).existsSync()) {
      return const DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFFECEEE8)),
        child: Icon(Icons.pets),
      );
    }
    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFFECEEE8)),
        child: Icon(Icons.pets),
      ),
    );
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
      _statusMessage = 'Getting your cattle notebook ready...';
    });

    try {
      await _embeddingService.loadModel();
      await _database.load();
      setState(() {
        _isReady = true;
        _statusMessage = 'Ready to identify cows and keep records.';
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
    _searchController.dispose();
    _embeddingService.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    AppLockController.instance.suspendLock();
    final XFile? image;
    try {
      image = await _picker.pickImage(
        source: source,
        imageQuality: 95,
        maxWidth: 1600,
      );
    } finally {
      AppLockController.instance.resumeLock();
    }

    if (image == null) {
      return;
    }
    final XFile selected = image;

    setState(() {
      _selectedImage = File(selected.path);
      _result = null;
      _statusMessage = _isReady
          ? 'Photo added. Tap Identify Cow.'
          : (_initializationError ??
                'App setup is not complete yet. Please retry.');
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
      _statusMessage = 'Checking cow...';
    });

    try {
      final IdentificationResult result = await _database.predictCow(
        _selectedImage!,
        embeddingService: _embeddingService,
      );

      setState(() {
        _result = result;
        _statusMessage = result.isKnown
            ? 'Cow identified.'
            : result.hasBorderlineMatch
            ? 'This looks like a cow you already have — see below.'
            : 'No matching cow found.';
      });

      if (result.hasBorderlineMatch && mounted) {
        await _showIdentifyBorderlineDialog(result);
      }
    } catch (error) {
      setState(() {
        _statusMessage = 'Could not identify this cow right now.';
      });
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  Future<void> _showRegisterDialog() async {
    if (!_isReady || _selectedImage == null) {
      return;
    }

    final TextEditingController idController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add this cow'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'Cow ID'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'e.g. Pregnant',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (idController.text.trim().isEmpty) {
                  return;
                }
                final String cowId = idController.text.trim();
                final String note = noteController.text.trim();
                Navigator.of(context).pop();
                await _prepareRegistration(cowId, note: note);
              },
              child: const Text('Add cow'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _prepareRegistration(String cowId, {String? note}) async {
    if (!_isReady || _selectedImage == null) {
      return;
    }

    setState(() {
      _isBusy = true;
      _statusMessage = 'Checking photo before registration...';
    });

    try {
      final List<double> embedding = await _embeddingService.getEmbedding(
        _selectedImage!,
      );

      if (_database.getCow(cowId) != null) {
        final bool? addPhoto = await _showDuplicateCowDialog(cowId);
        if (addPhoto == true) {
          await _addPhotoToExistingCow(cowId, embedding: embedding);
        }
        return;
      }

      final SimilarityMatch? similarMatch = _database.findBestSimilarCow(
        embedding,
      );
      if (similarMatch != null) {
        final String? action = await _showSimilarCowDialog(similarMatch);
        if (action == 'add_to_existing') {
          await _addPhotoToExistingCow(
            similarMatch.cowId,
            embedding: embedding,
          );
          return;
        }
        if (action != 'create_new') {
          setState(() {
            _statusMessage = 'Cancelled.';
          });
          return;
        }
      }

      await _registerCow(
        cowId,
        note: note,
        embedding: embedding,
      );
    } catch (error) {
      setState(() {
        _statusMessage = 'Could not check this photo before registration.';
      });
      _showSnack('Could not prepare registration');
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<bool?> _showDuplicateCowDialog(String cowId) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$cowId is already in your herd'),
          content: Text(
            'Add this photo to $cowId?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes, add to $cowId'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showIdentifyBorderlineDialog(IdentificationResult result) async {
    final String cowId = result.suggestedCowId!;
    final CowRecord? matchedCow = _database.getCow(cowId);

    final String? action = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('This looks like $cowId'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Add this photo to that cow?'),
              if (matchedCow?.profileImagePath != null) ...<Widget>[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: _cowAvatar(matchedCow!.profileImagePath),
                  ),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop('dismiss'),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('add_photo'),
              child: Text('Yes, add to $cowId'),
            ),
          ],
        );
      },
    );

    if (action == 'add_photo' && mounted) {
      await _addPhotoToExistingCow(cowId);
    }
  }

  Future<String?> _showSimilarCowDialog(SimilarityMatch match) {
    final CowRecord? matchedCow = _database.getCow(match.cowId);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('This looks like ${match.cowId}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Add this photo to ${match.cowId} instead?'),
              if (matchedCow?.profileImagePath != null) ...<Widget>[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: _cowAvatar(matchedCow!.profileImagePath),
                  ),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop('cancel'),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('add_to_existing'),
              child: Text('Yes, add to ${match.cowId}'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop('create_new'),
              child: const Text('Create new cow'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPhotoToExistingCow(
    String cowId, {
    List<double>? embedding,
  }) async {
    if (!_isReady || _selectedImage == null) {
      return;
    }

    setState(() {
      _isBusy = true;
      _statusMessage = 'Saving photo...';
    });

    try {
      final List<double> resolvedEmbedding = embedding ??
          await _embeddingService.getEmbedding(_selectedImage!);
      await _database.addCowPhoto(
        cowId: cowId,
        embedding: resolvedEmbedding,
        imagePath: _selectedImage!.path,
      );
      setState(() {
        _statusMessage = 'Photo added to $cowId.';
        _result = IdentificationResult(
          predictedCowId: cowId,
          similarity: 1,
          isKnown: true,
        );
      });
      _showSnack('Photo added to $cowId');
    } catch (error) {
      setState(() {
        _statusMessage = 'Could not save this photo.';
      });
      _showSnack('Could not add photo');
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _registerCow(
    String cowId, {
    String? note,
    List<double>? embedding,
  }) async {
    if (!_isReady || _selectedImage == null) {
      return;
    }

    setState(() {
      _isBusy = true;
      _statusMessage = 'Saving cow details...';
    });

    try {
      final List<double> resolvedEmbedding = embedding ??
          await _embeddingService.getEmbedding(_selectedImage!);
      await _database.registerCow(
        cowId: cowId,
        embedding: resolvedEmbedding,
        imagePath: _selectedImage!.path,
        note: note,
      );
      setState(() {
        _statusMessage = '$cowId added to your herd.';
        _result = const IdentificationResult(
          predictedCowId: 'Registered',
          similarity: 0,
          isKnown: true,
        );
      });
      _showSnack('$cowId added successfully');
    } catch (error) {
      setState(() {
        _statusMessage = 'Could not add this cow right now.';
      });
      _showSnack('Could not add cow');
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  Future<void> _openCowDetail(String cowId) async {
    final String? eventMessage = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => CowDetailPage(
          cowId: cowId,
          database: _database,
          embeddingService: _embeddingService,
        ),
      ),
    );
    if (!mounted) {
      return;
    }
    if (eventMessage != null && eventMessage.isNotEmpty) {
      _showSnack(eventMessage);
    }
    setState(() {});
  }

  Future<void> _handleBackNavigation() async {
    if (_currentTab == 1) {
      setState(() {
        _currentTab = 0;
      });
      return;
    }

    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit app'),
          content: const Text('Do you want to close the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldExit == true) {
      await SystemNavigator.pop();
    }
  }

  void _showSettingsSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change PIN'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showChangePinDialog();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showChangePinDialog() async {
    final TextEditingController currentPinController = TextEditingController();
    final TextEditingController newPinController = TextEditingController();
    final TextEditingController confirmPinController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change PIN'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: currentPinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    labelText: 'Current PIN',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: newPinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    labelText: 'New PIN',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmPinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    labelText: 'Confirm new PIN',
                    counterText: '',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final NavigatorState navigator = Navigator.of(context);
                final String currentPin = currentPinController.text.trim();
                final String newPin = newPinController.text.trim();
                final String confirmPin = confirmPinController.text.trim();

                if (!RegExp(r'^\d{4}$').hasMatch(currentPin) ||
                    !RegExp(r'^\d{4}$').hasMatch(newPin) ||
                    !RegExp(r'^\d{4}$').hasMatch(confirmPin)) {
                  _showSnack('PIN must be exactly 4 digits');
                  return;
                }
                if (newPin != confirmPin) {
                  _showSnack('New PIN does not match');
                  return;
                }

                final bool currentOk = await _appAuthService.verifyPin(
                  currentPin,
                );
                if (!currentOk) {
                  _showSnack('Current PIN is incorrect');
                  return;
                }

                await _appAuthService.savePin(newPin);
                if (!mounted) {
                  return;
                }
                navigator.pop();
                _showSnack('PIN changed successfully');
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIdentifyTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _HeaderCard(
            statusMessage: _statusMessage,
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
          const SizedBox(height: 20),
          Text(
            'Identification result',
            style: theme.textTheme.titleMedium?.copyWith(
              color: kFarmAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _PredictionCard(
            result: _result,
            matchedCow: _result?.suggestedCowId == null
                ? null
                : _database.getCow(_result!.suggestedCowId!),
            cowAvatarBuilder: _cowAvatar,
          ),
          if (_result?.hasBorderlineMatch == true &&
              _selectedImage != null) ...<Widget>[
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFFFFF3E0),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'This looks like ${_result!.suggestedCowId}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    const Text('Add this photo to that cow?'),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: (_isBusy || !_isReady)
                          ? null
                          : () => _addPhotoToExistingCow(
                                _result!.suggestedCowId!,
                              ),
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: Text(
                        'Yes, add to ${_result!.suggestedCowId}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if ((_result?.isKnown == false) &&
              _selectedImage != null) ...<Widget>[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: (_isBusy || !_isReady) ? null : _showRegisterDialog,
              icon: const Icon(Icons.app_registration),
              label: const Text('Add this cow'),
            ),
          ],
          if (_isBusy) ...<Widget>[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Widget _buildMyCowsTab(ThemeData theme) {
    final String query = _searchController.text.trim().toLowerCase();
    final List<CowRecord> cows = _database
        .getAllCows()
        .where((CowRecord cow) => cow.id.toLowerCase().contains(query))
        .toList();
    if (cows.isEmpty) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search your herd',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('No cows yet.\nUse Identify to add your first cow.'),
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search your herd',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemBuilder: (BuildContext context, int index) {
              final CowRecord cow = cows[index];
              return Card(
                child: ListTile(
                  onTap: () => _openCowDetail(cow.id),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: _cowAvatar(cow.profileImagePath),
                    ),
                  ),
                  title: Text(cow.id),
                  subtitle: Text(
                    'Health: ${cow.healthRecords.length} • '
                    'Vaccines: ${cow.vaccinations.length} • '
                    'Notes: ${cow.notes.length}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemCount: cows.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        _handleBackNavigation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentTab == 0 ? 'Identify Cow' : 'Your herd'),
          actions: <Widget>[
            if (_currentTab == 0)
              IconButton(
                onPressed: _showSettingsSheet,
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
              ),
          ],
        ),
        body: SafeArea(
          child: _currentTab == 0
              ? _buildIdentifyTab(theme)
              : _buildMyCowsTab(theme),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFFFFFDF7),
          indicatorColor: kFarmSecondary.withValues(alpha: 0.35),
          selectedIndex: _currentTab,
          onDestinationSelected: (int index) {
            setState(() {
              _currentTab = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(icon: Icon(Icons.search), label: 'Identify'),
            NavigationDestination(icon: Icon(Icons.list_alt), label: 'My Cows'),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.statusMessage,
    required this.cowCount,
    required this.isReady,
    required this.initializationError,
    required this.onRetry,
  });

  final String? statusMessage;
  final int cowCount;
  final bool isReady;
  final String? initializationError;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    final Color accent = isReady ? kFarmPrimary : kFarmAccent;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to your cattle notebook',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Take or upload a photo to identify a cow and keep simple records.',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kFarmSecondary.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Registered cows: $cowCount',
                style: TextStyle(color: accent, fontWeight: FontWeight.w700),
              ),
            ),
            if (initializationError != null) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                'Something went wrong while opening the app.',
                style: TextStyle(
                  color: kFarmAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
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
            ? const Center(child: Text('No photo selected'))
            : Image.file(imageFile!, fit: BoxFit.cover),
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard({
    required this.result,
    required this.matchedCow,
    required this.cowAvatarBuilder,
  });

  final IdentificationResult? result;
  final CowRecord? matchedCow;
  final Widget Function(String? imagePath) cowAvatarBuilder;

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Identify a cow to see the result here.'),
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
            Text(
              'Match confidence: ${(result!.similarity * 100).toStringAsFixed(1)}%',
            ),
            const SizedBox(height: 6),
            Text(
              result!.isKnown
                  ? 'This cow is already in your herd.'
                  : result!.hasBorderlineMatch
                  ? 'This looks like a cow you already have. See below.'
                  : 'No matching cow found. You can add this as a new cow.',
            ),
            if (result!.hasBorderlineMatch &&
                matchedCow?.profileImagePath != null) ...<Widget>[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: cowAvatarBuilder(matchedCow!.profileImagePath),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
