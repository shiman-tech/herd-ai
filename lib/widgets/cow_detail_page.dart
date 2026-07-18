import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
                        decoration: const InputDecoration(
                          labelText: 'Disease name',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Date: ${_formatDate(selectedDate)}'),
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
                            child: const Text('Pick date'),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: 'Ongoing',
                            child: Text('Ongoing'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Recovered',
                            child: Text('Recovered'),
                          ),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            setModalState(() => selectedStatus = value);
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Status'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: symptomsController,
                        decoration: const InputDecoration(
                          labelText: 'Symptoms (optional)',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: treatmentController,
                        decoration: const InputDecoration(
                          labelText: 'Treatment notes (optional)',
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
                                ? 'Health record added'
                                : 'Health record updated',
                          );
                        },
                        child: Text(
                          index == null
                              ? 'Save health record'
                              : 'Update health record',
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
                        decoration: const InputDecoration(
                          labelText: 'Vaccine name',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Given: ${_formatDate(givenDate)}'),
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
                            child: const Text('Pick date'),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              nextDueDate == null
                                  ? 'Next due: Not set'
                                  : 'Next due: ${_formatDate(nextDueDate!)}',
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
                            child: const Text('Set next due'),
                          ),
                        ],
                      ),
                      TextField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
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
                                ? 'Vaccination added'
                                : 'Vaccination updated',
                          );
                        },
                        child: Text(
                          index == null
                              ? 'Save vaccination'
                              : 'Update vaccination',
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
        return AlertDialog(
          title: const Text('Add a note'),
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
              child: const Text('Cancel'),
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
                _showSnack(index == null ? 'Note added' : 'Note updated');
              },
              child: const Text('Save'),
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
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Add photo',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('Take or choose a clear photo of this cow.'),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take photo'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
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
        return AlertDialog(
          title: Text('Add photo to $_cowId?'),
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
                const Text(
                  'This photo will be saved with today\'s date so you can track '
                  'how this cow looks over time. It will also help identify '
                  'this cow in the future.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Add photo'),
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
      _showSnack('Photo added');
    } catch (error) {
      if (mounted) {
        _showSnack('Could not add photo');
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
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Classify breed',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  'Take or choose a clear full-body photo of this cow.',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take photo'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
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
        return AlertDialog(
          title: const Text('Classify this photo?'),
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
                const Text(
                  'A clear, well-lit full-body photo gives the best breed '
                  'prediction.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Classify'),
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
          _showSnack('No breed predictions returned');
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
        _showSnack('Breed classified');
      }
    } catch (error) {
      if (mounted) {
        _showSnack('Could not classify breed');
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
      _showSnack('Breed confirmed: $breedName');
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
        return AlertDialog(
          title: const Text('Choose breed'),
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
                  const Text(
                    'Or type a breed name:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: customController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Jersey Cross',
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
                    child: const Text('Confirm custom breed'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
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
      _showSnack('Breed set to Unknown / Mixed');
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
        return AlertDialog(
          title: const Text('Replace this photo?'),
          content: const Text(
            'The old photo will be removed and replaced with the new one.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Replace'),
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
      _showSnack('Photo updated');
    } catch (error) {
      if (mounted) {
        _showSnack('Could not update photo');
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
        return AlertDialog(
          title: const Text('Delete health record'),
          content: const Text('Delete this health record?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
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
    _showSnack('Health record deleted');
  }

  Future<void> _confirmDeleteVaccinationRecord(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete vaccination'),
          content: const Text('Delete this vaccination record?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
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
    _showSnack('Vaccination deleted');
  }

  Future<void> _confirmDeleteNote(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete note'),
          content: const Text('Delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
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
    _showSnack('Note deleted');
  }

  Future<void> _confirmDeleteImage(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete photo'),
          content: const Text(
            'Delete this photo? It will also be removed from cow identification.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
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
    _showSnack('Photo deleted');
  }

  Future<void> _confirmDeleteCow() async {
    final CowRecord? record = _record;
    if (record == null) {
      return;
    }

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Cow Record'),
          content: Text('Delete ${record.id} and all related records?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
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
    Navigator.of(context).pop('Cow record deleted');
  }

  @override
  Widget build(BuildContext context) {
    final CowRecord? record = _record;
    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cow details')),
        body: const Center(child: Text('Cow record not found.')),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${record.id} details'),
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
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Overview'),
              Tab(text: 'Medical'),
              Tab(text: 'Gallery & Notes'),
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
                    'Basic info',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: kFarmAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Cow ID: ${record.id}'),
                  Text('Registered: ${_formatDate(record.registrationDate)}'),
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
            title: 'Breed Classification',
            buttonLabel: record.displayBreed == null
                ? 'Classify Breed'
                : 'Re-classify',
            onAdd: _classifyBreed,
            child: Builder(
              builder: (BuildContext context) {
                if (record.displayBreed == null &&
                    record.breedAlternativesJson == null) {
                  return const Text(
                    'No breed classification yet. Take a full-body photo.',
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
                        'Confirmed Breed: ${record.confirmedBreed}',
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
                      const Text(
                        'Low confidence — try a clearer full-body photo.',
                        style: TextStyle(
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
                            child: const Text('Set Manually'),
                          ),
                          OutlinedButton(
                            onPressed: _setUnknownBreed,
                            child: const Text('Unknown / Mixed'),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Likely breeds (visual estimate):'),
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
                            child: Text('Confirm ${alternatives.first.name}'),
                          ),
                        OutlinedButton(
                          onPressed: _chooseDifferentBreed,
                          child: const Text('Choose different'),
                        ),
                        OutlinedButton(
                          onPressed: _setUnknownBreed,
                          child: const Text('Unknown / Mixed'),
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
            title: 'Health Records',
            buttonLabel: 'Add Health Record',
            onAdd: _addHealthRecord,
            child: record.healthRecords.isEmpty
                ? const Text('No health records yet.')
                : Column(
                    children: record.healthRecords.asMap().entries.map((
                      MapEntry<int, HealthRecord> entry,
                    ) {
                      final int index = entry.key;
                      final HealthRecord item = entry.value;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.medical_services_outlined),
                        title: Text(item.diseaseName),
                        subtitle: Text(
                          '${item.status} • ${_formatDate(item.date)}\n'
                          '${item.symptoms.isEmpty ? 'No symptoms noted' : item.symptoms}',
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
                          itemBuilder: (_) => const <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          _SectionCard(
            title: 'Vaccination Records',
            buttonLabel: 'Add Vaccination',
            onAdd: _addVaccinationRecord,
            child: record.vaccinations.isEmpty
                ? const Text('No vaccination records yet.')
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
                          'Given: ${_formatDate(item.dateGiven)}'
                          '${item.nextDueDate == null ? '' : '\nNext due: ${_formatDate(item.nextDueDate!)}'}',
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
                          itemBuilder: (_) => const <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
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
            title: 'Notes',
            buttonLabel: 'Add Note',
            onAdd: _addNote,
            child: record.notes.isEmpty
                ? const Text('No notes added.')
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
                          itemBuilder: (_) => const <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          _SectionCard(
            title: 'Photos',
            buttonLabel: 'Add Photo',
            onAdd: _addImageToHistory,
            buttonEnabled: !_isBusy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Track how this cow looks over time. Newest photos appear first.',
                ),
                if (_isBusy) ...<Widget>[
                  const SizedBox(height: 10),
                  const LinearProgressIndicator(),
                ],
                const SizedBox(height: 10),
                if (record.images.isEmpty && !_isBusy)
                  const Text('No photos yet.')
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
                                        const <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Text('Replace'),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text('Delete'),
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
