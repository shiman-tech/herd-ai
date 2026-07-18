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
import 'services/tflite_breed_service.dart';
import 'services/tflite_embedding_service.dart';
import 'widgets/auth_gate.dart';
import 'widgets/cow_detail_page.dart';

import 'l10n/app_localizations.dart';
import 'services/app_language_service.dart';

const Color kFarmPrimary = Color(0xFF2D6A4F);
const Color kFarmSecondary = Color(0xFF95A97F);
const Color kFarmBackground = Color(0xFFF4F1E6);
const Color kFarmAccent = Color(0xFF8D6E63);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLanguageService.instance.loadLocale();
  runApp(const HerdAiApp());
}

class HerdAiApp extends StatelessWidget {
  const HerdAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguageService.instance,
      builder: (BuildContext context, _) {
        return MaterialApp(
          title: 'Herd AI',
          locale: AppLanguageService.instance.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
      },
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
  final TfliteBreedService _breedService = TfliteBreedService();
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
      _statusMessage = null;
    });

    try {
      await _embeddingService.loadModel();
      await _breedService.loadModel();
      await _database.load();
      if (!mounted) {
        return;
      }
      setState(() {
        _isReady = true;
        _statusMessage = AppLocalizations.of(context)!.readyToIdentify;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
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
    _breedService.dispose();
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
          ? AppLocalizations.of(context)!.tapIdentify
          : (_initializationError ??
                AppLocalizations.of(context)!.notReady);
    });
  }

  Future<void> _identifyCow() async {
    if (!_isReady || _selectedImage == null) {
      setState(() {
        _statusMessage = AppLocalizations.of(context)!.selectImage;
      });
      return;
    }

    setState(() {
      _isBusy = true;
      _statusMessage = AppLocalizations.of(context)!.checkingCow;
    });

    try {
      final IdentificationResult result = await _database.predictCow(
        _selectedImage!,
        embeddingService: _embeddingService,
      );

      setState(() {
        _result = result;
        _statusMessage = result.isKnown
            ? AppLocalizations.of(context)!.cowIdentified
            : result.hasBorderlineMatch
            ? AppLocalizations.of(context)!.borderlineMatch
            : AppLocalizations.of(context)!.noMatchingCow;
      });

      if (result.hasBorderlineMatch && mounted) {
        await _showIdentifyBorderlineDialog(result);
      }
    } catch (error) {
      setState(() {
        _statusMessage = AppLocalizations.of(context)!.couldNotIdentify;
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
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.addThisCow),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: localizations.cowId),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: localizations.optionalNote,
                  hintText: 'e.g. Pregnant',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancel),
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
              child: Text(localizations.addCow),
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
      _statusMessage = AppLocalizations.of(context)!.checkingPhotoBeforeReg;
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
            _statusMessage = AppLocalizations.of(context)!.cancelled;
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
        _statusMessage = AppLocalizations.of(context)!.couldNotCheckPhoto;
      });
      _showSnack(AppLocalizations.of(context)!.couldNotPrepareReg);
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
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.alreadyInHerd(cowId)),
          content: Text(
            localizations.addPhotoTo(cowId),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.no),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.yesAddTo(cowId)),
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
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.looksLike(cowId)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localizations.addPhotoToThat),
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
              child: Text(localizations.no),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('add_photo'),
              child: Text(localizations.yesAddTo(cowId)),
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
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.looksLike(match.cowId)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localizations.addPhotoToThat),
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
              child: Text(localizations.no),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('add_to_existing'),
              child: Text(localizations.yesAddTo(match.cowId)),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop('create_new'),
              child: Text(localizations.createNewCow),
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
      _statusMessage = AppLocalizations.of(context)!.savingPhoto;
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
        _statusMessage = AppLocalizations.of(context)!.photoAddedTo(cowId);
        _result = IdentificationResult(
          predictedCowId: cowId,
          similarity: 1,
          isKnown: true,
        );
      });
      _showSnack(AppLocalizations.of(context)!.photoAddedTo(cowId));
    } catch (error) {
      setState(() {
        _statusMessage = AppLocalizations.of(context)!.couldNotSavePhoto;
      });
      _showSnack(AppLocalizations.of(context)!.couldNotAddPhoto);
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
      _statusMessage = AppLocalizations.of(context)!.savingCowDetails;
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
        _statusMessage = AppLocalizations.of(context)!.addedToHerd(cowId);
        _result = const IdentificationResult(
          predictedCowId: 'Registered',
          similarity: 0,
          isKnown: true,
        );
      });
      _showSnack(AppLocalizations.of(context)!.addedSuccessfully(cowId));
    } catch (error) {
      setState(() {
        _statusMessage = AppLocalizations.of(context)!.couldNotIdentify;
      });
      _showSnack(AppLocalizations.of(context)!.failedToRegister);
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
          breedService: _breedService,
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
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.exitApp),
          content: Text(localizations.exitAppConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.no),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.yes),
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
        final localizations = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  localizations.settings,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(localizations.changePin),
                onTap: () {
                  Navigator.of(context).pop();
                  _showChangePinDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(localizations.language),
                trailing: Text(
                  AppLanguageService.instance.locale.languageCode == 'en' ? 'English' : 'हिन्दी',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showLanguageDialog();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('English'),
                trailing: AppLanguageService.instance.locale.languageCode == 'en'
                    ? const Icon(Icons.check, color: kFarmPrimary)
                    : null,
                onTap: () {
                  AppLanguageService.instance.changeLanguage('en');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('हिन्दी'),
                trailing: AppLanguageService.instance.locale.languageCode == 'hi'
                    ? const Icon(Icons.check, color: kFarmPrimary)
                    : null,
                onTap: () {
                  AppLanguageService.instance.changeLanguage('hi');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancel),
            ),
          ],
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
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.changePin),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: currentPinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: localizations.currentPin,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: newPinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: localizations.newPin,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmPinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: localizations.confirmNewPin,
                    counterText: '',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancel),
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
                  _showSnack(localizations.invalidPinLength);
                  return;
                }
                if (newPin != confirmPin) {
                  _showSnack(localizations.pinsDoNotMatch);
                  return;
                }

                final bool currentOk = await _appAuthService.verifyPin(
                  currentPin,
                );
                if (!currentOk) {
                  _showSnack(localizations.wrongCurrentPin);
                  return;
                }

                await _appAuthService.savePin(newPin);
                if (!mounted) {
                  return;
                }
                navigator.pop();
                _showSnack(localizations.pinChanged);
              },
              child: Text(localizations.save),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIdentifyTab(ThemeData theme) {
    final localizations = AppLocalizations.of(context)!;
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
                label: Text(localizations.captureImage),
              ),
              OutlinedButton.icon(
                onPressed: _isBusy
                    ? null
                    : () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(localizations.uploadImage),
              ),
              FilledButton.tonalIcon(
                onPressed: (_isBusy || !_isReady) ? null : _identifyCow,
                icon: const Icon(Icons.search),
                label: Text(localizations.identifyCow),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            localizations.identificationResult,
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
                      localizations.looksLike(_result!.suggestedCowId!),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(localizations.addPhotoToThat),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: (_isBusy || !_isReady)
                          ? null
                          : () => _addPhotoToExistingCow(
                                _result!.suggestedCowId!,
                              ),
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: Text(
                        localizations.yesAddTo(_result!.suggestedCowId!),
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
              label: Text(localizations.addThisCow),
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
    final localizations = AppLocalizations.of(context)!;
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
                hintText: localizations.searchHint,
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
            child: Center(
              child: Text(localizations.noCowsMessage),
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
              hintText: localizations.searchHint,
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
                    localizations.cowSummarySubtitle(
                      cow.healthRecords.length,
                      cow.vaccinations.length,
                      cow.notes.length,
                    ),
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
    final localizations = AppLocalizations.of(context)!;

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
          title: Text(_currentTab == 0 ? localizations.identifyCow : localizations.yourHerd),
          actions: <Widget>[
            if (_currentTab == 0)
              IconButton(
                onPressed: _showSettingsSheet,
                icon: const Icon(Icons.settings_outlined),
                tooltip: localizations.settings,
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
          destinations: <NavigationDestination>[
            NavigationDestination(icon: const Icon(Icons.search), label: localizations.identifyTab),
            NavigationDestination(icon: const Icon(Icons.list_alt), label: localizations.cowsTab),
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
    final localizations = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.welcomeNotebook,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.notebookDescription,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kFarmSecondary.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                localizations.registeredCowsCount(cowCount),
                style: TextStyle(color: accent, fontWeight: FontWeight.w700),
              ),
            ),
            if (initializationError != null) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                localizations.initErrorOccurred,
                style: TextStyle(
                  color: kFarmAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(localizations.tryAgain),
              ),
            ],
            if (statusMessage != null || (!isReady && initializationError == null)) ...<Widget>[
              const SizedBox(height: 8),
              Text(statusMessage ?? localizations.initializingDb),
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
    final localizations = AppLocalizations.of(context)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 260,
        child: imageFile == null
            ? Center(child: Text(localizations.noPhotoSelected))
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
    final localizations = AppLocalizations.of(context)!;
    if (result == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(localizations.identifyResultPlaceholder),
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
              result!.predictedCowId == 'Registered'
                  ? localizations.cowRegistered
                  : (result!.predictedCowId == 'Unknown Cow'
                      ? localizations.unknownCow
                      : result!.predictedCowId),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.matchConfidence((result!.similarity * 100).toStringAsFixed(1)),
            ),
            const SizedBox(height: 6),
            Text(
              result!.isKnown
                  ? localizations.cowAlreadyInHerd
                  : result!.hasBorderlineMatch
                  ? localizations.borderlineMatch
                  : localizations.noMatchingCowRegisterHint,
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
