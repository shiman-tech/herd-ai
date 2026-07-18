import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../models/breed_prediction.dart';
import '../models/cow_image.dart';
import '../models/cow_record.dart';
import '../services/app_lock_controller.dart';
import '../services/embedding_database.dart';
import '../services/tflite_breed_service.dart';
import '../services/tflite_embedding_service.dart';

const Color kFarmPrimary = Color(0xFF2D6A4F);
const Color kFarmSecondary = Color(0xFF95A97F);
const Color kFarmAccent = Color(0xFF8D6E63);

class CowDetailPage extends StatefulWidget {
  const CowDetailPage({
    super.key,
    required this.cowId,
    required this.database,
    required this.embeddingService,
    required this.breedService,
  });

  final String cowId;
  final EmbeddingDatabase database;
  final TfliteEmbeddingService embeddingService;
  final TfliteBreedService breedService;

  @override
  State<CowDetailPage> createState() => _CowDetailPageState();
}

class _CowDetailPageState extends State<CowDetailPage> with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  late String _cowId;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _cowId = widget.cowId;
  }

  CowRecord? get _record => widget.database.getCow(_cowId);

  Widget _imageOrPlaceholder(String? imagePath, {double size = 100}) {
    if (imagePath == null || !File(imagePath).existsSync()) {
      return SizedBox(
        width: size,
        height: size,
        child: const DecoratedBox(
          decoration: BoxDecoration(color: Color(0xFFECEEE8)),
          child: Icon(Icons.pets),
        ),
      );
    }
    return Image.file(
      File(imagePath),
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => SizedBox(
        width: size,
        height: size,
        child: const DecoratedBox(
          decoration: BoxDecoration(color: Color(0xFFECEEE8)),
          child: Icon(Icons.pets),
        ),
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

  void _showFullScreenImage(String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Center(
              child: InteractiveViewer(
                child: Image.file(File(imagePath)),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _showBasicInfoDialog() async {
    final CowRecord? record = _record;
    if (record == null) {
      return;
    }

    final TextEditingController idController = TextEditingController(
      text: record.id,
    );
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit cow details'),
          content: TextField(
            controller: idController,
            decoration: const InputDecoration(labelText: 'Cow ID'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final NavigatorState navigator = Navigator.of(context);
                await widget.database.updateCowBasicInfo(
                  oldCowId: record.id,
                  newCowId: idController.text.trim(),
                );
                if (!mounted) {
                  return;
                }
                setState(() {
                  _cowId = idController.text.trim();
                });
                navigator.pop();
                _showSnack('Cow details updated');
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addHealthRecord() async {
    await _upsertHealthRecord();
  }

  Future<void> _upsertHealthRecord({int? index}) async {
    final HealthRecord? existing = index == null
        ? null
        : _record?.healthRecords[index];
    final TextEditingController diseaseController = TextEditingController();
    final TextEditingController symptomsController = TextEditingController();
    final TextEditingController treatmentController = TextEditingController();
    diseaseController.text = existing?.diseaseName ?? '';
    symptomsController.text = existing?.symptoms ?? '';
    treatmentController.text = existing?.treatmentNotes ?? '';
    DateTime selectedDate = existing?.date ?? DateTime.now();
    String selectedStatus = existing?.status ?? 'Ongoing';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder:
              (
                BuildContext context,
                void Function(void Function()) setModalState,
              ) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: diseaseController,
                        decoration: InputDecoration(
                          labelText: localizations.diseaseNameLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(localizations.dateLabel2(_formatDate(selectedDate))),
                          ),
                          TextButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: selectedDate,
                              );
                              if (picked != null) {
                                setModalState(() => selectedDate = picked);
                              }
                            },
                            child: Text(localizations.pickDate),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                        items: <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: 'Ongoing',
                            child: Text(localizations.ongoing),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Recovered',
                            child: Text(localizations.recovered),
                          ),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            setModalState(() => selectedStatus = value);
                          }
                        },
                        decoration: InputDecoration(labelText: localizations.status),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: symptomsController,
                        decoration: InputDecoration(
                          labelText: localizations.symptomsOptional,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: treatmentController,
                        decoration: InputDecoration(
                          labelText: localizations.treatmentNotesOptional,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () async {
                          final NavigatorState navigator = Navigator.of(
                            context,
                          );
                          if (diseaseController.text.trim().isEmpty) {
                            return;
                          }
                          final HealthRecord payload = HealthRecord(
                            diseaseName: diseaseController.text.trim(),
                            date: selectedDate,
                            status: selectedStatus,
                            symptoms: symptomsController.text.trim(),
                            treatmentNotes: treatmentController.text.trim(),
                          );
                          if (index == null) {
                            await widget.database.addHealthRecord(
                              _cowId,
                              payload,
                            );
                          } else {
                            await widget.database.updateHealthRecord(
                              cowId: _cowId,
                              index: index,
                              healthRecord: payload,
                            );
                          }
                          if (!mounted) {
                            return;
                          }
                          setState(() {});
                          navigator.pop();
                          _showSnack(
                            index == null
                                ? localizations.healthRecordAdded
                                : localizations.healthRecordUpdated,
                          );
                        },
                        child: Text(
                          index == null
                              ? localizations.saveHealthRecord
                              : localizations.updateHealthRecord,
                        ),
                      ),
                    ],
                  ),
                );
              },
        );
      },
    );
  }

  Future<void> _addVaccinationRecord() async {
    await _upsertVaccinationRecord();
  }

  Future<void> _upsertVaccinationRecord({int? index}) async {
    final VaccinationRecord? existing = index == null
        ? null
        : _record?.vaccinations[index];
    final TextEditingController vaccineController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    vaccineController.text = existing?.vaccineName ?? '';
    notesController.text = existing?.notes ?? '';
    DateTime givenDate = existing?.dateGiven ?? DateTime.now();
    DateTime? nextDueDate = existing?.nextDueDate;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder:
              (
                BuildContext context,
                void Function(void Function()) setModalState,
              ) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: vaccineController,
                        decoration: InputDecoration(
                          labelText: localizations.vaccineNameLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(localizations.givenLabel2(_formatDate(givenDate))),
                          ),
                          TextButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: givenDate,
                              );
                              if (picked != null) {
                                setModalState(() => givenDate = picked);
                              }
                            },
                            child: Text(localizations.pickDate),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              nextDueDate == null
                                  ? localizations.nextDueNotSet
                                  : localizations.nextDueLabel2(_formatDate(nextDueDate!)),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: nextDueDate ?? givenDate,
                              );
                              if (picked != null) {
                                setModalState(() => nextDueDate = picked);
                              }
                            },
                            child: Text(localizations.setNextDue),
                          ),
                        ],
                      ),
                      TextField(
                        controller: notesController,
                        decoration: InputDecoration(
                          labelText: localizations.notesOptional,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () async {
                          final NavigatorState navigator = Navigator.of(
                            context,
                          );
                          if (vaccineController.text.trim().isEmpty) {
                            return;
                          }
                          final VaccinationRecord payload = VaccinationRecord(
                            vaccineName: vaccineController.text.trim(),
                            dateGiven: givenDate,
                            nextDueDate: nextDueDate,
                            notes: notesController.text.trim(),
                          );
                          if (index == null) {
                            await widget.database.addVaccinationRecord(
                              _cowId,
                              payload,
                            );
                          } else {
                            await widget.database.updateVaccinationRecord(
                              cowId: _cowId,
                              index: index,
                              vaccinationRecord: payload,
                            );
                          }
                          if (!mounted) {
                            return;
                          }
                          setState(() {});
                          navigator.pop();
                          _showSnack(
                            index == null
                                ? localizations.vaccinationAdded
                                : localizations.vaccinationUpdated,
                          );
                        },
                        child: Text(
                          index == null
                              ? localizations.saveVaccination
                              : localizations.updateVaccination,
                        ),
                      ),
                    ],
                  ),
                );
              },
        );
      },
    );
  }

  Future<void> _addNote() async {
    await _upsertNote();
  }

  Future<void> _upsertNote({int? index}) async {
    final String? existing = index == null ? null : _record?.notes[index];
    final TextEditingController noteController = TextEditingController();
    noteController.text = existing ?? '';
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.addNoteDialogTitle),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
              hintText: 'e.g. Not eating properly',
            ),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final NavigatorState navigator = Navigator.of(context);
                if (index == null) {
                  await widget.database.addNote(_cowId, noteController.text);
                } else {
                  await widget.database.updateNote(
                    cowId: _cowId,
                    index: index,
                    note: noteController.text,
                  );
                }
                if (!mounted) {
                  return;
                }
                setState(() {});
                navigator.pop();
                _showSnack(index == null ? localizations.noteAdded : localizations.noteUpdated);
              },
              child: Text(localizations.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addImageToHistory() async {
    if (_isBusy) {
      return;
    }

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  localizations.addPhoto,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(localizations.takeOrChooseClear),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(localizations.takePhoto),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(localizations.chooseFromGallery),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (source == null) {
      return;
    }

    AppLockController.instance.suspendLock();
    final XFile? picked;
    try {
      picked = await _picker.pickImage(
        source: source,
        imageQuality: 95,
        maxWidth: 1600,
      );
    } finally {
      AppLockController.instance.resumeLock();
    }
    if (picked == null) {
      return;
    }
    final XFile selectedImage = picked;

    if (!mounted) {
      return;
    }
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.addPhotoTo(_cowId)),
          content: SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 160,
                    width: 280,
                    child: Image.file(
                      File(selectedImage.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(localizations.addPhotoConfirm),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.addPhoto),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }

    setState(() => _isBusy = true);
    try {
      final List<double> embedding = await widget.embeddingService.getEmbedding(
        File(selectedImage.path),
      );
      await widget.database.addCowPhoto(
        cowId: _cowId,
        embedding: embedding,
        imagePath: selectedImage.path,
      );
      if (!mounted) {
        return;
      }
      setState(() {});
      _showSnack(AppLocalizations.of(context)!.photoAdded);
    } catch (error) {
      if (mounted) {
        _showSnack(AppLocalizations.of(context)!.couldNotAddPhoto);
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Breed Classification
  // ---------------------------------------------------------------------------

  List<BreedPrediction> _parseAlternatives(String? json) {
    if (json == null || json.isEmpty) {
      return <BreedPrediction>[];
    }
    try {
      final dynamic decoded = jsonDecode(json);
      if (decoded is List<dynamic>) {
        return decoded
            .map(
              (dynamic e) =>
                  BreedPrediction.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
    } catch (_) {
      // Ignore malformed JSON.
    }
    return <BreedPrediction>[];
  }

  Future<void> _classifyBreed() async {
    if (_isBusy) {
      return;
    }

    // Let the user pick a source (camera or gallery).
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  localizations.classifyBreed,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  localizations.takeOrChooseFullBody,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(localizations.takePhoto),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(localizations.chooseFromGallery),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (source == null) {
      return;
    }

    AppLockController.instance.suspendLock();
    final XFile? picked;
    try {
      picked = await _picker.pickImage(
        source: source,
        imageQuality: 95,
        maxWidth: 1600,
      );
    } finally {
      AppLockController.instance.resumeLock();
    }
    if (picked == null || !mounted) {
      return;
    }
    final File selectedImage = File(picked.path);

    // Show a confirmation preview before running inference.
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.classifyThisPhoto),
          content: SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 180,
                    width: 280,
                    child: Image.file(selectedImage, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 12),
                Text(localizations.classifyThisPhotoConfirm),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.classify),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _isBusy = true);
    try {
      final List<BreedPrediction> predictions = await widget.breedService
          .classifyBreed(selectedImage);
      if (predictions.isEmpty) {
        if (mounted) {
          _showSnack(AppLocalizations.of(context)!.noBreedPredictions);
        }
        return;
      }
      await widget.database.saveBreedResult(
        cowId: _cowId,
        breedName: predictions.first.name,
        breedConfidence: predictions.first.confidence,
        alternatives: predictions,
      );
      if (mounted) {
        setState(() {});
        _showSnack(AppLocalizations.of(context)!.breedClassified);
      }
    } catch (error) {
      if (mounted) {
        _showSnack(AppLocalizations.of(context)!.couldNotClassify);
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _confirmBreed(String breedName) async {
    await widget.database.confirmBreed(
      cowId: _cowId,
      confirmedBreed: breedName,
    );
    if (mounted) {
      setState(() {});
      _showSnack(AppLocalizations.of(context)!.breedConfirmed(breedName));
    }
  }

  Future<void> _chooseDifferentBreed() async {
    final CowRecord? record = _record;
    if (record == null) {
      return;
    }
    final List<BreedPrediction> alternatives = _parseAlternatives(
      record.breedAlternativesJson,
    );
    final List<String> breedNames = alternatives
        .map((BreedPrediction p) => p.name)
        .toList();

    // Ensure the existing top-1 is in the list so we never lose it.
    if (record.breedName != null && !breedNames.contains(record.breedName)) {
      breedNames.insert(0, record.breedName!);
    }

    final TextEditingController customController = TextEditingController();

    final String? chosen = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.chooseBreed),
          content: SizedBox(
            width: 280,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ...breedNames.map(
                    (String name) => ListTile(
                      title: Text(name),
                      trailing: name == record.confirmedBreed
                          ? const Icon(Icons.check, color: kFarmPrimary)
                          : null,
                      onTap: () => Navigator.of(context).pop(name),
                    ),
                  ),
                  const Divider(),
                  Text(
                    localizations.orTypeBreedName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: customController,
                    decoration: InputDecoration(
                      hintText: localizations.customBreedHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () {
                      final String text = customController.text.trim();
                      if (text.isNotEmpty) {
                        Navigator.of(context).pop(text);
                      }
                    },
                    child: Text(localizations.confirmCustomBreed),
                  ),
                ],
              ),
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
    if (chosen != null && chosen.isNotEmpty && mounted) {
      await _confirmBreed(chosen);
    }
  }

  Future<void> _setUnknownBreed() async {
    await widget.database.confirmBreed(
      cowId: _cowId,
      confirmedBreed: 'Unknown / Mixed',
    );
    if (mounted) {
      setState(() {});
      _showSnack(AppLocalizations.of(context)!.breedSetUnknown);
    }
  }

  Future<void> _replaceImageAt(int index) async {
    AppLockController.instance.suspendLock();
    final XFile? picked;
    try {
      picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
        maxWidth: 1600,
      );
    } finally {
      AppLockController.instance.resumeLock();
    }
    if (picked == null) {
      return;
    }
    final XFile selectedImage = picked;

    if (!mounted) {
      return;
    }
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.replacePhoto),
          content: Text(localizations.replacePhotoConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.replace),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }

    setState(() => _isBusy = true);
    try {
      final List<double> embedding = await widget.embeddingService.getEmbedding(
        File(selectedImage.path),
      );
      await widget.database.replaceCowPhoto(
        cowId: _cowId,
        index: index,
        embedding: embedding,
        imagePath: selectedImage.path,
      );
      if (!mounted) {
        return;
      }
      setState(() {});
      _showSnack(AppLocalizations.of(context)!.photoUpdated);
    } catch (error) {
      if (mounted) {
        _showSnack(AppLocalizations.of(context)!.couldNotUpdatePhoto);
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _confirmDeleteHealthRecord(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.deleteHealthRecord),
          content: Text(localizations.deleteHealthRecordConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await widget.database.deleteHealthRecord(_cowId, index);
    if (!mounted) {
      return;
    }
    setState(() {});
    _showSnack(AppLocalizations.of(context)!.healthRecordDeleted);
  }

  Future<void> _confirmDeleteVaccinationRecord(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.deleteVaccination),
          content: Text(localizations.deleteVaccinationConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await widget.database.deleteVaccinationRecord(_cowId, index);
    if (!mounted) {
      return;
    }
    setState(() {});
    _showSnack(AppLocalizations.of(context)!.vaccinationDeleted);
  }

  Future<void> _confirmDeleteNote(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.deleteNote),
          content: Text(localizations.deleteNoteConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await widget.database.deleteNote(_cowId, index);
    if (!mounted) {
      return;
    }
    setState(() {});
    _showSnack(AppLocalizations.of(context)!.noteDeleted);
  }

  Future<void> _confirmDeleteImage(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.deletePhoto),
          content: Text(localizations.deletePhotoConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await widget.database.deleteImage(_cowId, index);
    if (!mounted) {
      return;
    }
    setState(() {});
    _showSnack(AppLocalizations.of(context)!.photoDeleted);
  }

  Future<void> _confirmDeleteCow() async {
    final CowRecord? record = _record;
    if (record == null) {
      return;
    }

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.deleteCowRecord),
          content: Text(localizations.deleteCowRecordConfirm(record.id)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.delete),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await widget.database.deleteCow(record.id);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(AppLocalizations.of(context)!.cowRecordDeleted);
  }

  @override
  Widget build(BuildContext context) {
    final CowRecord? record = _record;
    final localizations = AppLocalizations.of(context)!;
    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.cowDetails)),
        body: Center(child: Text(localizations.cowNotFound)),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.detailsHeader(record.id)),
          actions: <Widget>[
            IconButton(
              onPressed: _showBasicInfoDialog,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: _confirmDeleteCow,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: localizations.tabOverview),
              Tab(text: localizations.tabMedical),
              Tab(text: localizations.tabGalleryNotes),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // Overview Tab
            ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.basicInfo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: kFarmAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(localizations.cowIdLabel(record.id)),
                  Text(localizations.registeredLabel(_formatDate(record.registrationDate))),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: record.profileImagePath == null
                          ? _imageOrPlaceholder(null, size: 120)
                          : GestureDetector(
                              onTap: () => _showFullScreenImage(record.profileImagePath!),
                              child: _imageOrPlaceholder(
                                record.profileImagePath,
                                size: 120,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _SectionCard(
            title: localizations.breedClassification,
            buttonLabel: record.displayBreed == null
                ? localizations.classifyBreed
                : localizations.reClassify,
            onAdd: _classifyBreed,
            child: Builder(
              builder: (BuildContext context) {
                if (record.displayBreed == null &&
                    record.breedAlternativesJson == null) {
                  return Text(
                    localizations.noBreedClassificationYet,
                  );
                }

                final List<BreedPrediction> alternatives = _parseAlternatives(
                  record.breedAlternativesJson,
                );

                if (record.breedConfirmedByUser) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        localizations.confirmedBreed(record.confirmedBreed ?? ''),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }

                final double topConfidence =
                    record.breedConfidence ??
                    (alternatives.isNotEmpty
                        ? alternatives.first.confidence
                        : 0.0);

                if (topConfidence < 0.40) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        localizations.lowConfidenceWarning,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          OutlinedButton(
                            onPressed: _chooseDifferentBreed,
                            child: Text(localizations.setManually),
                          ),
                          OutlinedButton(
                            onPressed: _setUnknownBreed,
                            child: Text(localizations.unknownMixed),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(localizations.likelyBreedsVisual),
                    const SizedBox(height: 8),
                    ...alternatives.take(3).map((BreedPrediction p) {
                      final int percent = (p.confidence * 100).round();
                      return Text('• ${p.name} — $percent%');
                    }),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        if (alternatives.isNotEmpty)
                          FilledButton(
                            onPressed: () =>
                                _confirmBreed(alternatives.first.name),
                            child: Text(localizations.confirmBreed(alternatives.first.name)),
                          ),
                        OutlinedButton(
                          onPressed: _chooseDifferentBreed,
                          child: Text(localizations.chooseDifferent),
                        ),
                        OutlinedButton(
                          onPressed: _setUnknownBreed,
                          child: Text(localizations.unknownMixed),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      // Medical Tab
      ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _SectionCard(
            title: localizations.healthRecords,
            buttonLabel: localizations.addHealthRecord,
            onAdd: _addHealthRecord,
            child: record.healthRecords.isEmpty
                ? Text(localizations.noHealthRecords)
                : Column(
                    children: record.healthRecords.asMap().entries.map((
                      MapEntry<int, HealthRecord> entry,
                    ) {
                      final int index = entry.key;
                      final HealthRecord item = entry.value;
                      final String statusLabel = item.status == 'Ongoing'
                          ? localizations.ongoing
                          : (item.status == 'Recovered'
                              ? localizations.recovered
                              : item.status);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.medical_services_outlined),
                        title: Text(item.diseaseName),
                        subtitle: Text(
                          '$statusLabel • ${_formatDate(item.date)}\n'
                          '${item.symptoms.isEmpty ? localizations.noSymptomsNoted : item.symptoms}',
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String action) {
                            if (action == 'edit') {
                              _upsertHealthRecord(index: index);
                            } else {
                              _confirmDeleteHealthRecord(index);
                            }
                          },
                          itemBuilder: (_) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text(localizations.edit),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text(localizations.delete),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          _SectionCard(
            title: localizations.vaccinationRecords,
            buttonLabel: localizations.addVaccination,
            onAdd: _addVaccinationRecord,
            child: record.vaccinations.isEmpty
                ? Text(localizations.noVaccinationRecords)
                : Column(
                    children: record.vaccinations.asMap().entries.map((
                      MapEntry<int, VaccinationRecord> entry,
                    ) {
                      final int index = entry.key;
                      final VaccinationRecord item = entry.value;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.vaccines_outlined),
                        title: Text(item.vaccineName),
                        subtitle: Text(
                          '${localizations.givenLabel2(_formatDate(item.dateGiven))}'
                          '${item.nextDueDate == null ? '' : '\n${localizations.nextDueLabel2(_formatDate(item.nextDueDate!))}'}',
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String action) {
                            if (action == 'edit') {
                              _upsertVaccinationRecord(index: index);
                            } else {
                              _confirmDeleteVaccinationRecord(index);
                            }
                          },
                          itemBuilder: (_) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text(localizations.edit),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text(localizations.delete),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
      // Gallery & Notes Tab
      ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _SectionCard(
            title: localizations.notes,
            buttonLabel: localizations.addNote,
            onAdd: _addNote,
            child: record.notes.isEmpty
                ? Text(localizations.noNotes)
                : Column(
                    children: record.notes.asMap().entries.map((
                      MapEntry<int, String> entry,
                    ) {
                      final int index = entry.key;
                      final String note = entry.value;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.note_alt_outlined),
                        title: Text(note),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String action) {
                            if (action == 'edit') {
                              _upsertNote(index: index);
                            } else {
                              _confirmDeleteNote(index);
                            }
                          },
                          itemBuilder: (_) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text(localizations.edit),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text(localizations.delete),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          _SectionCard(
            title: localizations.photos,
            buttonLabel: localizations.addPhoto,
            onAdd: _addImageToHistory,
            buttonEnabled: !_isBusy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  localizations.photoDesc,
                ),
                if (_isBusy) ...<Widget>[
                  const SizedBox(height: 10),
                  const LinearProgressIndicator(),
                ],
                const SizedBox(height: 10),
                if (record.images.isEmpty && !_isBusy)
                  Text(localizations.noPhotos)
                else if (record.images.isNotEmpty)
                  SizedBox(
                    height: 132,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int displayIndex) {
                        final CowImage image =
                            record.imagesNewestFirst[displayIndex];
                        final int index = record.images.indexWhere(
                          (CowImage item) => item.path == image.path,
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => _showFullScreenImage(image.path),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _imageOrPlaceholder(
                                      image.path,
                                      size: 100,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                    color: const Color(0xFFFFFEFA),
                                    onSelected: (String action) {
                                      if (action == 'edit') {
                                        _replaceImageAt(index);
                                      } else {
                                        _confirmDeleteImage(index);
                                      }
                                    },
                                    itemBuilder: (_) =>
                                        <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Text(localizations.replace),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text(localizations.delete),
                                          ),
                                        ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(image.uploadedAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: record.images.length,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.buttonLabel,
    required this.onAdd,
    required this.child,
    this.buttonEnabled = true,
  });

  final String title;
  final String buttonLabel;
  final VoidCallback onAdd;
  final Widget child;
  final bool buttonEnabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: kFarmAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 176,
                  height: 38,
                  child: FilledButton(
                    onPressed: buttonEnabled ? onAdd : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFF3EDDE),
                      foregroundColor: kFarmPrimary,
                      minimumSize: const Size(176, 38),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          color: kFarmPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
