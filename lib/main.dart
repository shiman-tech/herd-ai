import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'models/cattle_filter.dart';
import 'models/cattle_record.dart';
import 'models/embedding_reference.dart';
import 'models/identification_result.dart';
import 'services/app_auth_service.dart';
import 'services/app_lock_controller.dart';
import 'services/embedding_database.dart';
import 'services/tflite_breed_service.dart';
import 'services/tflite_embedding_service.dart';
import 'widgets/auth_gate.dart';
import 'widgets/cattle_detail_page.dart';
import 'widgets/cattle_filter_sheet.dart';

import 'l10n/app_localizations.dart';
import 'services/app_language_service.dart';

const Color kFarmPrimary = Color(0xFF2D6A4F);
const Color kFarmSecondary = Color(0xFF95A97F);
const Color kFarmBackground = Color(0xFFF4F1E6);
const Color kFarmAccent = Color(0xFF8D6E63);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Start preloading language and database in parallel at app launch
  await Future.wait(<Future<void>>[
    AppLanguageService.instance.loadLocale(),
    EmbeddingDatabase.instance.load(),
  ]);
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
            elevation: 3,
            shadowColor: Colors.black26,
            minimumSize: const Size(140, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
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
            side: const BorderSide(color: kFarmAccent, width: 1.5),
            minimumSize: const Size(140, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
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
  final EmbeddingDatabase _database = EmbeddingDatabase.instance;
  final TextEditingController _searchController = TextEditingController();
  final CattleFilterCriteria _filterCriteria = CattleFilterCriteria();

  File? _selectedImage;
  int _currentTab = 0;
  bool _isBusy = false;
  bool _isReady = false;
  String? _initializationError;
  String? Function(BuildContext)? _statusResolver;
  IdentificationResult? _result;
  bool _ignoreSimilarWarning = false;

  Future<void> _openFilterSheet() async {
    final List<CattleRecord> allCattle = _database.getAllCattle();
    final CattleFilterCriteria? updated =
        await showModalBottomSheet<CattleFilterCriteria>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => CattleFilterSheet(
        initialFilter: _filterCriteria,
        allCattle: allCattle,
        searchQuery: _searchController.text,
      ),
    );
    if (updated != null && mounted) {
      setState(() {
        _filterCriteria.selectedSexes
          ..clear()
          ..addAll(updated.selectedSexes);
        _filterCriteria.selectedLifeStages
          ..clear()
          ..addAll(updated.selectedLifeStages);
        _filterCriteria.selectedHealthStatuses
          ..clear()
          ..addAll(updated.selectedHealthStatuses);
        _filterCriteria.selectedReproductiveStatuses
          ..clear()
          ..addAll(updated.selectedReproductiveStatuses);
        _filterCriteria.selectedVaccinationStatuses
          ..clear()
          ..addAll(updated.selectedVaccinationStatuses);
        _filterCriteria.selectedBreeds
          ..clear()
          ..addAll(updated.selectedBreeds);
        _filterCriteria.sortOption = updated.sortOption;
      });
    }
  }

  Widget _cattleAvatar(String? imagePath) {
    if (imagePath == null || !File(imagePath).existsSync()) {
      return const DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFFECEEE8)),
        child: Icon(Icons.pets),
      );
    }
    return Image.file(
      File(imagePath),
      cacheWidth: 150,
      fit: BoxFit.cover,
      gaplessPlayback: true,
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
      _statusResolver = null;
    });

    try {
      // Load all ML models and database in parallel rather than sequentially
      await Future.wait(<Future<void>>[
        _embeddingService.loadModel(),
        _breedService.loadModel(),
        _database.load(),
      ]);
      if (!mounted) {
        return;
      }
      setState(() {
        _isReady = true;
        _statusResolver = (context) => AppLocalizations.of(context)!.readyToIdentify;
      });

      // Pre-warm thumbnail images into memory in the background for instant rendering
      _precacheThumbnails();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _initializationError = error.toString();
        _statusResolver = (context) => _initializationError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  void _precacheThumbnails() {
    final List<CattleRecord> all = _database.getAllCattle();
    for (final CattleRecord cattle in all) {
      final String? path = cattle.profileImagePath;
      if (path != null && File(path).existsSync()) {
        precacheImage(
          ResizeImage(FileImage(File(path)), width: 150),
          context,
        );
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
      _ignoreSimilarWarning = false;
      _statusResolver = (context) => _isReady
          ? AppLocalizations.of(context)!.tapIdentify
          : (_initializationError ??
                AppLocalizations.of(context)!.notReady);
    });
  }

  Future<void> _identifyCattle() async {
    if (!_isReady || _selectedImage == null) {
      setState(() {
        _statusResolver = (context) => AppLocalizations.of(context)!.selectImage;
      });
      return;
    }

    setState(() {
      _isBusy = true;
      _statusResolver = (context) => AppLocalizations.of(context)!.checkingCattle;
    });

    try {
      final IdentificationResult result = await _database.predictCattle(
        _selectedImage!,
        embeddingService: _embeddingService,
      );

      setState(() {
        _result = result;
        _statusResolver = (context) {
          if (result.isKnown) {
            return AppLocalizations.of(context)!.cattleIdentified;
          } else if (result.hasBorderlineMatch) {
            return AppLocalizations.of(context)!.borderlineMatch;
          } else {
            return AppLocalizations.of(context)!.noMatchingCattle;
          }
        };
      });

      if (result.hasBorderlineMatch && mounted) {
        await _showIdentifyBorderlineDialog(result);
      }
    } catch (error) {
      setState(() {
        _statusResolver = (context) => AppLocalizations.of(context)!.couldNotIdentify;
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
    String selectedSex = 'Female';

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text(localizations.addThisCattle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(labelText: localizations.cattleId),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: selectedSex,
                    decoration: const InputDecoration(
                      labelText: 'Sex *',
                    ),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                    ],
                    onChanged: (String? val) {
                      if (val != null) {
                        setDialogState(() => selectedSex = val);
                      }
                    },
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
                    final String cattleId = idController.text.trim();
                    final String note = noteController.text.trim();
                    Navigator.of(context).pop();
                    await _prepareRegistration(cattleId, sex: selectedSex, note: note);
                  },
                  child: Text(localizations.addCattle),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _prepareRegistration(String cattleId, {required String sex, String? note}) async {
    if (!_isReady || _selectedImage == null) {
      return;
    }

    setState(() {
      _isBusy = true;
      _statusResolver = (context) => AppLocalizations.of(context)!.checkingPhotoBeforeReg;
    });

    try {
      final List<double> embedding = await _embeddingService.getEmbedding(
        _selectedImage!,
      );

      if (_database.getCattle(cattleId) != null) {
        final bool? addPhoto = await _showDuplicateCattleDialog(cattleId);
        if (addPhoto == true) {
          await _addPhotoToExistingCattle(cattleId, embedding: embedding);
        }
        return;
      }

      if (!_ignoreSimilarWarning) {
        final SimilarityMatch? similarMatch = _database.findBestSimilarCattle(
          embedding,
        );
        if (similarMatch != null) {
          final String? action = await _showSimilarCattleDialog(similarMatch);
          if (action == 'add_to_existing') {
            await _addPhotoToExistingCattle(
              similarMatch.cattleId,
              embedding: embedding,
            );
            return;
          }
          if (action != 'create_new') {
            _ignoreSimilarWarning = true;
            setState(() {
              _statusResolver = (context) => AppLocalizations.of(context)!.cancelled;
            });
            return;
          }
        }
      }

      await _registerCattle(
        cattleId,
        sex: sex,
        note: note,
        embedding: embedding,
      );
    } catch (error) {
      setState(() {
        _statusResolver = (context) => AppLocalizations.of(context)!.couldNotCheckPhoto;
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

  Future<bool?> _showDuplicateCattleDialog(String cattleId) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.alreadyInHerd(cattleId)),
          content: Text(
            localizations.addPhotoTo(cattleId),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.no),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.yesAddTo(cattleId)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showIdentifyBorderlineDialog(IdentificationResult result) async {
    final String cattleId = result.suggestedCattleId!;
    final CattleRecord? matchedCattle = _database.getCattle(cattleId);

    final String? action = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.looksLike(cattleId)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localizations.addPhotoToThat),
              if (matchedCattle?.profileImagePath != null) ...<Widget>[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: _cattleAvatar(matchedCattle!.profileImagePath),
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
              child: Text(localizations.yesAddTo(cattleId)),
            ),
          ],
        );
      },
    );

    if (action == 'add_photo' && mounted) {
      await _addPhotoToExistingCattle(cattleId);
    } else {
      _ignoreSimilarWarning = true;
    }
  }

  Future<String?> _showSimilarCattleDialog(SimilarityMatch match) {
    final CattleRecord? matchedCattle = _database.getCattle(match.cattleId);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.looksLike(match.cattleId)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(localizations.addPhotoToThat),
              if (matchedCattle?.profileImagePath != null) ...<Widget>[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: _cattleAvatar(matchedCattle!.profileImagePath),
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
              child: Text(localizations.yesAddTo(match.cattleId)),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop('create_new'),
              child: Text(localizations.createNewCattle),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPhotoToExistingCattle(
    String cattleId, {
    List<double>? embedding,
  }) async {
    if (!_isReady || _selectedImage == null) {
      return;
    }

    setState(() {
      _isBusy = true;
      _statusResolver = (context) => AppLocalizations.of(context)!.savingPhoto;
    });

    try {
      final List<double> resolvedEmbedding = embedding ??
          await _embeddingService.getEmbedding(_selectedImage!);
      await _database.addCattlePhoto(
        cattleId: cattleId,
        embedding: resolvedEmbedding,
        imagePath: _selectedImage!.path,
      );
      setState(() {
        _statusResolver = (context) => AppLocalizations.of(context)!.photoAddedTo(cattleId);
        _result = IdentificationResult(
          predictedCattleId: cattleId,
          similarity: 1,
          isKnown: true,
        );
      });
      _showSnack(AppLocalizations.of(context)!.photoAddedTo(cattleId));
    } catch (error) {
      setState(() {
        _statusResolver = (context) => AppLocalizations.of(context)!.couldNotSavePhoto;
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

  Future<void> _registerCattle(
    String cattleId, {
    required String sex,
    String? note,
    List<double>? embedding,
  }) async {
    if (!_isReady || _selectedImage == null) {
      return;
    }

    setState(() {
      _isBusy = true;
      _statusResolver = (context) => AppLocalizations.of(context)!.savingCattleDetails;
    });

    try {
      final List<double> resolvedEmbedding = embedding ??
          await _embeddingService.getEmbedding(_selectedImage!);
      await _database.registerCattle(
        cattleId: cattleId,
        embedding: resolvedEmbedding,
        imagePath: _selectedImage!.path,
        sex: sex,
        note: note,
      );
      setState(() {
        _statusResolver = (context) => AppLocalizations.of(context)!.addedToHerd(cattleId);
        _result = const IdentificationResult(
          predictedCattleId: 'Registered',
          similarity: 0,
          isKnown: true,
        );
      });
      _showSnack(AppLocalizations.of(context)!.addedSuccessfully(cattleId));
    } catch (error) {
      setState(() {
        _statusResolver = (context) => AppLocalizations.of(context)!.couldNotIdentify;
      });
      _showSnack(AppLocalizations.of(context)!.failedToRegister);
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  Future<void> _openCattleDetail(String cattleId) async {
    final String? eventMessage = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => CattleDetailPage(
          cattleId: cattleId,
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
                  _localeDisplayName(AppLanguageService.instance.locale.languageCode),
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

  String _localeDisplayName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिन्दी (Hindi)';
      case 'bn':
        return 'বাংলা (Bengali)';
      case 'gu':
        return 'ગુજરાતી (Gujarati)';
      case 'kn':
        return 'ಕನ್ನಡ (Kannada)';
      case 'mr':
        return 'मराठी (Marathi)';
      case 'or':
        return 'ଓଡ଼ିଆ (Odia)';
      case 'ta':
        return 'தமிழ் (Tamil)';
      case 'te':
        return 'తెలుగు (Telugu)';
      case 'ur':
        return 'اردو (Urdu)';
      default:
        return code;
    }
  }

  void _showLanguageDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        final currentLanguageCode = AppLanguageService.instance.locale.languageCode;
        return AlertDialog(
          title: Text(localizations.selectLanguage),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AppLocalizations.supportedLocales.length,
              itemBuilder: (BuildContext context, int index) {
                final locale = AppLocalizations.supportedLocales[index];
                final code = locale.languageCode;
                final displayName = _localeDisplayName(code);
                return ListTile(
                  title: Text(displayName),
                  trailing: currentLanguageCode == code
                      ? const Icon(Icons.check, color: kFarmPrimary)
                      : null,
                  onTap: () {
                    AppLanguageService.instance.changeLanguage(code);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
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
            statusMessage: _statusResolver?.call(context),
            cattleCount: _database.totalCattle,
            isReady: _isReady,
            initializationError: _initializationError,
            onRetry: _isBusy ? null : _initialize,
          ),
          const SizedBox(height: 16),
          _ImagePreviewCard(imageFile: _selectedImage),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isBusy
                      ? null
                      : () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(localizations.captureImage),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isBusy
                      ? null
                      : () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(localizations.uploadImage),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: FilledButton.tonalIcon(
              onPressed: (_isBusy || !_isReady) ? null : _identifyCattle,
              icon: const Icon(Icons.search),
              label: Text(localizations.identifyCattle),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
            ),
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
            matchedCattle: _result?.suggestedCattleId == null
                ? null
                : _database.getCattle(_result!.suggestedCattleId!),
            cattleAvatarBuilder: _cattleAvatar,
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
                      localizations.looksLike(_result!.suggestedCattleId!),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(localizations.addPhotoToThat),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: (_isBusy || !_isReady)
                          ? null
                          : () => _addPhotoToExistingCattle(
                                _result!.suggestedCattleId!,
                              ),
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: Text(
                        localizations.yesAddTo(_result!.suggestedCattleId!),
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
              label: Text(localizations.addThisCattle),
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

  Widget _buildMyCattlesTab(ThemeData theme) {
    final localizations = AppLocalizations.of(context)!;
    final List<CattleRecord> allCattle = _database.getAllCattle();
    final List<CattleRecord> filteredCattle = _filterCriteria.filterAndSort(
      allCattle,
      _searchController.text,
    );
    final String query = _searchController.text.trim();
    final List<ActiveFilterItem> activeFilters = _filterCriteria.activeFilterItems;
    final int activeCount = _filterCriteria.activeFilterCount;

    return Column(
      children: <Widget>[
        // Top Search + Filter Button Row
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: localizations.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              const SizedBox(width: 8),
              Badge(
                isLabelVisible: activeCount > 0,
                label: Text(
                  '$activeCount',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                backgroundColor: const Color(0xFF2D6A4F),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: activeCount > 0 ? const Color(0xFF2D6A4F) : Colors.grey.shade400,
                      width: activeCount > 0 ? 1.5 : 1.0,
                    ),
                  ),
                  onPressed: _openFilterSheet,
                  icon: Icon(
                    Icons.tune,
                    size: 20,
                    color: activeCount > 0 ? const Color(0xFF2D6A4F) : Colors.black87,
                  ),
                  label: Text(
                    'Filter',
                    style: TextStyle(
                      color: activeCount > 0 ? const Color(0xFF2D6A4F) : Colors.black87,
                      fontWeight: activeCount > 0 ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Active filter chips row (if any)
        if (activeFilters.isNotEmpty)
          Container(
            height: 38,
            margin: const EdgeInsets.only(top: 4, bottom: 2),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: <Widget>[
                ...activeFilters.map((ActiveFilterItem item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InputChip(
                      label: Text('${item.category}: ${item.label}'),
                      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: const Color(0xFF2D6A4F).withValues(alpha: 0.08),
                      deleteIcon: const Icon(Icons.cancel, size: 16),
                      onDeleted: () {
                        setState(() {
                          _filterCriteria.removeFilter(item);
                        });
                      },
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ActionChip(
                    label: const Text('Clear all', style: TextStyle(fontSize: 12, color: Colors.red)),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.red.withValues(alpha: 0.08),
                    onPressed: () {
                      setState(() {
                        _filterCriteria.reset();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

        // Subtitle row: Showing X cattle + Sort indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Showing ${filteredCattle.length} of ${allCattle.length} cattle',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: _openFilterSheet,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.sort, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _filterCriteria.sortOption.label,
                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // List / Empty state
        Expanded(
          child: allCattle.isEmpty
              ? Center(
                  child: Text(localizations.noCattlesMessage),
                )
              : filteredCattle.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'No cattle match the selected filters.',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          FilledButton.tonal(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _filterCriteria.reset();
                              });
                            },
                            child: const Text('Reset Search & Filters'),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (BuildContext context, int index) {
                        final CattleRecord cattle = filteredCattle[index];
                        return Card(
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            onTap: () => _openCattleDetail(cattle.id),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: _cattleAvatar(cattle.profileImagePath),
                              ),
                            ),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    cattle.id,
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Icon(
                                  cattle.effectiveSex == 'Female'
                                      ? Icons.female
                                      : (cattle.effectiveSex == 'Male' ? Icons.male : Icons.transgender),
                                  size: 18,
                                  color: cattle.effectiveSex == 'Female' ? Colors.pink : Colors.blue,
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemCount: filteredCattle.length,
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
          title: Text(_currentTab == 0 ? localizations.identifyCattle : localizations.yourHerd),
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
          child: IndexedStack(
            index: _currentTab,
            children: <Widget>[
              _buildIdentifyTab(theme),
              _buildMyCattlesTab(theme),
            ],
          ),
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
            NavigationDestination(icon: const Icon(Icons.list_alt), label: localizations.cattleTab),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.statusMessage,
    required this.cattleCount,
    required this.isReady,
    required this.initializationError,
    required this.onRetry,
  });

  final String? statusMessage;
  final int cattleCount;
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
                localizations.registeredCattlesCount(cattleCount),
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
    required this.matchedCattle,
    required this.cattleAvatarBuilder,
  });

  final IdentificationResult? result;
  final CattleRecord? matchedCattle;
  final Widget Function(String? imagePath) cattleAvatarBuilder;

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
              result!.predictedCattleId == 'Registered'
                  ? localizations.cattleRegistered
                  : (result!.predictedCattleId == 'Unknown Cattle'
                      ? localizations.unknownCattle
                      : result!.predictedCattleId),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.matchConfidence((result!.similarity * 100).toStringAsFixed(1)),
            ),
            const SizedBox(height: 6),
            Text(
              result!.isKnown
                  ? localizations.cattleAlreadyInHerd
                  : result!.hasBorderlineMatch
                  ? localizations.borderlineMatch
                  : localizations.noMatchingCattleRegisterHint,
            ),
            if (result!.hasBorderlineMatch &&
                matchedCattle?.profileImagePath != null) ...<Widget>[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: cattleAvatarBuilder(matchedCattle!.profileImagePath),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
