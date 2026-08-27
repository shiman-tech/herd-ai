import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../models/breed_prediction.dart';
import '../models/cattle_image.dart';
import '../models/cattle_record.dart';
import '../models/milk_record.dart';
import '../services/app_lock_controller.dart';
import '../services/embedding_database.dart';
import '../services/milk_analytics_service.dart';
import '../services/tflite_breed_service.dart';
import '../services/tflite_embedding_service.dart';
import '../utils/math_utils.dart';
import 'milk_chart_widgets.dart';
import 'milk_entry_dialog.dart';

const Color kFarmPrimary = Color(0xFF2D6A4F);
const Color kFarmSecondary = Color(0xFF95A97F);
const Color kFarmAccent = Color(0xFF8D6E63);

class CattleDetailPage extends StatefulWidget {
  const CattleDetailPage({
    super.key,
    required this.cattleId,
    required this.database,
    required this.embeddingService,
    required this.breedService,
  });

  final String cattleId;
  final EmbeddingDatabase database;
  final TfliteEmbeddingService embeddingService;
  final TfliteBreedService breedService;

  @override
  State<CattleDetailPage> createState() => _CattleDetailPageState();
}

class _CattleDetailPageState extends State<CattleDetailPage> with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  late String _cattleId;
  bool _isBusy = false;
  String _selectedChartRange = '30D';

  @override
  void initState() {
    super.initState();
    _cattleId = widget.cattleId;
  }

  CattleRecord? get _record => widget.database.getCattle(_cattleId);

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
    final CattleRecord? record = _record;
    if (record == null) {
      return;
    }

    final TextEditingController idController = TextEditingController(
      text: record.id,
    );
    String selectedSex = (record.effectiveSex == 'Male') ? 'Male' : 'Female';
    DateTime? selectedDob = record.dateOfBirth;
    const List<String> validStages = <String>['Calf', 'Heifer', 'Steer', 'Unknown'];
    String selectedLifeStage = validStages.contains(record.effectiveLifeStage) ? record.effectiveLifeStage : 'Unknown';
    const List<String> validRepro = <String>['Not Pregnant', 'Pregnant', 'Unknown'];
    String selectedReproductive = validRepro.contains(record.effectiveReproductiveStatus)
        ? record.effectiveReproductiveStatus
        : 'Unknown';
    const List<String> validHealth = <String>['Healthy', 'Under Observation', 'Diseased', 'Recovered', 'Unknown'];
    String selectedHealth = validHealth.contains(record.effectiveHealthStatus) ? record.effectiveHealthStatus : 'Unknown';
    bool selectedMilking = record.isMilking;
    bool selectedPregnant = record.isPregnant;
    DateTime? selectedCalvingDate = record.calvingDate;
    DateTime? selectedInseminationDate = record.inseminationDate;
    DateTime? selectedDryOffDate = record.dryOffDate;
    final TextEditingController expectedYieldController = TextEditingController(
      text: record.expectedDailyYield != null ? record.expectedDailyYield.toString() : '',
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              title: const Text('Edit Cattle Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Cattle ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sex
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedSex,
                      decoration: const InputDecoration(
                        labelText: 'Sex',
                        border: OutlineInputBorder(),
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                      ],
                      onChanged: (String? val) {
                        if (val != null) {
                          setModalState(() {
                            selectedSex = val;
                            if (val == 'Male') {
                              selectedReproductive = 'Unknown';
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Date of Birth / Age
                    InkWell(
                      onTap: () async {
                        final DateTime now = DateTime.now();
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: now,
                          initialDate: selectedDob ?? now.subtract(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setModalState(() {
                            selectedDob = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date of Birth (Age)',
                          border: const OutlineInputBorder(),
                          suffixIcon: selectedDob != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    setModalState(() {
                                      selectedDob = null;
                                    });
                                  },
                                )
                              : const Icon(Icons.calendar_today, size: 18),
                        ),
                        child: Builder(
                          builder: (BuildContext context) {
                            if (selectedDob == null) {
                              return const Text('Not set', style: TextStyle(color: Colors.grey));
                            }
                            final DateTime now = DateTime.now();
                            int months = (now.year - selectedDob!.year) * 12 + (now.month - selectedDob!.month);
                            if (now.day < selectedDob!.day) months--;
                            months = months >= 0 ? months : 0;
                            final int years = months ~/ 12;
                            final int remMonths = months % 12;
                            String ageStr;
                            if (years > 0 && remMonths > 0) {
                              ageStr = '$years yr${years > 1 ? 's' : ''} $remMonths mo${remMonths > 1 ? 's' : ''}';
                            } else if (years > 0) {
                              ageStr = '$years yr${years > 1 ? 's' : ''}';
                            } else {
                              ageStr = '$remMonths mo${remMonths > 1 ? 's' : ''}';
                            }
                            return Text(
                              '${_formatDate(selectedDob!)}  ($ageStr)',
                              style: const TextStyle(color: Colors.black87),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Life Stage
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedLifeStage,
                      decoration: const InputDecoration(
                        labelText: 'Life Stage',
                        border: OutlineInputBorder(),
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'Unknown', child: Text('Unknown')),
                        DropdownMenuItem(value: 'Calf', child: Text('Calf')),
                        DropdownMenuItem(value: 'Heifer', child: Text('Heifer')),
                        DropdownMenuItem(value: 'Steer', child: Text('Steer')),
                      ],
                      onChanged: (String? val) {
                        if (val != null) {
                          setModalState(() => selectedLifeStage = val);
                        }
                      },
                    ),

                    // Health Status
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedHealth,
                      decoration: const InputDecoration(
                        labelText: 'Health Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'Unknown', child: Text('Unknown')),
                        DropdownMenuItem(value: 'Healthy', child: Text('Healthy')),
                        DropdownMenuItem(value: 'Under Observation', child: Text('Under Observation')),
                        DropdownMenuItem(value: 'Diseased', child: Text('Diseased')),
                        DropdownMenuItem(value: 'Recovered', child: Text('Recovered')),
                      ],
                      onChanged: (String? val) {
                        if (val != null) {
                          setModalState(() => selectedHealth = val);
                        }
                      },
                    ),

                    // Reproductive & Dairy Status (Female only)
                    if (selectedSex == 'Female') ...<Widget>[
                      const SizedBox(height: 14),
                      const Divider(),
                      const Text(
                        'Milk & Lactation Profile',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF2D6A4F)),
                      ),
                      const SizedBox(height: 8),

                      SwitchListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Currently Milking', style: TextStyle(fontWeight: FontWeight.w600)),
                        value: selectedMilking,
                        activeThumbColor: const Color(0xFF2D6A4F),
                        onChanged: (bool val) {
                          setModalState(() => selectedMilking = val);
                        },
                      ),

                      SwitchListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Pregnant', style: TextStyle(fontWeight: FontWeight.w600)),
                        value: selectedPregnant,
                        activeThumbColor: const Color(0xFF8E24AA),
                        onChanged: (bool val) {
                          setModalState(() {
                            selectedPregnant = val;
                            selectedReproductive = val ? 'Pregnant' : 'Not Pregnant';
                          });
                        },
                      ),

                      // Last Calving Date
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          final DateTime now = DateTime.now();
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: now,
                            initialDate: selectedCalvingDate ?? now,
                          );
                          if (picked != null) {
                            setModalState(() {
                              // If a new calving date is set, automatically reset pregnancy & insemination
                              final bool isNewCalving = record.calvingDate == null ||
                                  picked.isAfter(record.calvingDate!) ||
                                  selectedPregnant;
                              selectedCalvingDate = picked;
                              if (isNewCalving) {
                                selectedMilking = true;
                                selectedPregnant = false;
                                selectedReproductive = 'Not Pregnant';
                                selectedInseminationDate = null;
                                selectedDryOffDate = null;
                              }
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Last Calving Date',
                            border: const OutlineInputBorder(),
                            suffixIcon: selectedCalvingDate != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      setModalState(() {
                                        selectedCalvingDate = null;
                                      });
                                    },
                                  )
                                : const Icon(Icons.calendar_today, size: 18),
                          ),
                          child: Text(
                            selectedCalvingDate != null
                                ? _formatDate(selectedCalvingDate!)
                                : 'Not set',
                            style: TextStyle(
                              color: selectedCalvingDate != null ? Colors.black87 : Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      // Insemination Date
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () async {
                          final DateTime now = DateTime.now();
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: now,
                            initialDate: selectedInseminationDate ?? now,
                          );
                          if (picked != null) {
                            setModalState(() {
                              selectedInseminationDate = picked;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Insemination Date',
                            border: const OutlineInputBorder(),
                            suffixIcon: selectedInseminationDate != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      setModalState(() {
                                        selectedInseminationDate = null;
                                      });
                                    },
                                  )
                                : const Icon(Icons.calendar_today, size: 18),
                          ),
                          child: Text(
                            selectedInseminationDate != null
                                ? _formatDate(selectedInseminationDate!)
                                : 'Not set',
                            style: TextStyle(
                              color: selectedInseminationDate != null ? Colors.black87 : Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      // Expected Daily Yield
                      const SizedBox(height: 12),
                      TextField(
                        controller: expectedYieldController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Expected Daily Yield (Benchmark)',
                          hintText: 'e.g. 15.0',
                          suffixText: 'L/day',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
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
                    final String newId = idController.text.trim();
                    if (newId.isEmpty) {
                      return;
                    }
                    final double? expYield = double.tryParse(expectedYieldController.text.trim());
                    final NavigatorState navigator = Navigator.of(context);
                    await widget.database.updateCattleBasicInfo(
                      oldCattleId: record.id,
                      newCattleId: newId,
                      sex: selectedSex,
                      dateOfBirth: selectedDob,
                      lifeStage: selectedLifeStage,
                      healthStatus: selectedHealth,
                      reproductiveStatus: selectedReproductive,
                      isMilking: selectedMilking,
                      isPregnant: selectedPregnant,
                      calvingDate: selectedCalvingDate,
                      inseminationDate: selectedInseminationDate,
                      dryOffDate: selectedDryOffDate,
                      expectedDailyYield: expYield,
                    );
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      _cattleId = newId;
                    });
                    navigator.pop();
                    _showSnack('Cattle details updated');
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
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
    const List<String> validHealthOptions = <String>[
      'Healthy',
      'Under Observation',
      'Diseased',
      'Recovered',
    ];
    String selectedStatus = existing?.status ?? 'Diseased';
    if (!validHealthOptions.contains(selectedStatus)) {
      if (selectedStatus == 'Ongoing') {
        selectedStatus = 'Diseased';
      } else {
        selectedStatus = 'Diseased';
      }
    }

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
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: 'Diseased',
                            child: Text('Diseased'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Under Observation',
                            child: Text('Under Observation'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Recovered',
                            child: Text('Recovered'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Healthy',
                            child: Text('Healthy'),
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
                              _cattleId,
                              payload,
                            );
                          } else {
                            await widget.database.updateHealthRecord(
                              cattleId: _cattleId,
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
                              _cattleId,
                              payload,
                            );
                          } else {
                            await widget.database.updateVaccinationRecord(
                              cattleId: _cattleId,
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
                  await widget.database.addNote(_cattleId, noteController.text);
                } else {
                  await widget.database.updateNote(
                    cattleId: _cattleId,
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

  Future<ImageSource?> _pickImageSource(String title) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
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
  }

  // ---------------------------------------------------------------------------
  // Cattle Identification Photos (facial, adds embedding)
  // ---------------------------------------------------------------------------

  Future<void> _addIdentityPhoto() async {
    if (_isBusy) return;

    final ImageSource? source = await _pickImageSource(
      AppLocalizations.of(context)!.cattleIdentification,
    );
    if (source == null) return;

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
    if (picked == null) return;
    final XFile selectedImage = picked;

    if (!mounted) return;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.addPhotoTo(_cattleId)),
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
                    child: Image.file(File(selectedImage.path), fit: BoxFit.cover),
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
    if (confirmed != true) return;

    setState(() => _isBusy = true);
    try {
      final List<double> embedding = await widget.embeddingService.getEmbedding(
        File(selectedImage.path),
      );

      final CattleRecord? record = _record;
      if (record != null && record.embeddings.isNotEmpty) {
        double maxSimilarity = -1.0;
        for (final ref in record.embeddings) {
          final double sim = cosineSimilarity(embedding, ref.vector);
          if (sim > maxSimilarity) maxSimilarity = sim;
        }
        if (maxSimilarity < 0.75 && mounted) {
          final bool? proceed = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              final localizations = AppLocalizations.of(context)!;
              return AlertDialog(
                title: Text(localizations.lowConfidenceWarning),
                content: const Text(
                  "This doesn't look like the same cattle. Add it anyway?",
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
          if (proceed != true) return;
        }
      }

      await widget.database.addCattlePhoto(
        cattleId: _cattleId,
        embedding: embedding,
        imagePath: selectedImage.path,
        isIdentity: true,
      );
      if (!mounted) return;
      setState(() {});
      _showSnack(AppLocalizations.of(context)!.photoAdded);
    } catch (error) {
      if (mounted) _showSnack(AppLocalizations.of(context)!.couldNotAddPhoto);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Photo Gallery (appearance tracking, no embedding)
  // ---------------------------------------------------------------------------

  Future<void> _addGalleryPhoto() async {
    if (_isBusy) return;

    final ImageSource? source = await _pickImageSource(
      AppLocalizations.of(context)!.photos,
    );
    if (source == null) return;

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
    if (picked == null) return;
    final XFile selectedImage = picked;

    if (!mounted) return;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.addPhotoTo(_cattleId)),
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
                    child: Image.file(File(selectedImage.path), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 12),
                Text(localizations.galleryPhotoConfirm),
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
    if (confirmed != true) return;

    setState(() => _isBusy = true);
    try {
      final List<double> embedding = await widget.embeddingService.getEmbedding(
        File(selectedImage.path),
      );
      await widget.database.addCattlePhoto(
        cattleId: _cattleId,
        embedding: embedding,
        imagePath: selectedImage.path,
        isIdentity: false,
      );
      if (!mounted) return;
      setState(() {});
      _showSnack(AppLocalizations.of(context)!.photoAdded);
    } catch (error) {
      if (mounted) _showSnack(AppLocalizations.of(context)!.couldNotAddPhoto);
    } finally {
      if (mounted) setState(() => _isBusy = false);
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
      final BreedPrediction topPrediction = predictions.first;
      if (topPrediction.confidence < 0.60) {
        await widget.database.saveBreedResult(
          cattleId: _cattleId,
          breedName: 'Unknown',
          breedConfidence: topPrediction.confidence,
          alternatives: predictions,
        );
        if (mounted) {
          setState(() {});
          _showSnack('Low confidence. Marked as Unknown.');
        }
      } else {
        await widget.database.saveBreedResult(
          cattleId: _cattleId,
          breedName: topPrediction.name,
          breedConfidence: topPrediction.confidence,
          alternatives: predictions,
        );
        if (mounted) {
          setState(() {});
          _showSnack(AppLocalizations.of(context)!.breedClassified);
        }
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
      cattleId: _cattleId,
      confirmedBreed: breedName,
    );
    if (mounted) {
      setState(() {});
      _showSnack(AppLocalizations.of(context)!.breedConfirmed(breedName));
    }
  }

  Future<void> _chooseDifferentBreed() async {
    final CattleRecord? record = _record;
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
      cattleId: _cattleId,
      confirmedBreed: 'Unknown',
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
      await widget.database.replaceCattlePhoto(
        cattleId: _cattleId,
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
    await widget.database.deleteHealthRecord(_cattleId, index);
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
    await widget.database.deleteVaccinationRecord(_cattleId, index);
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
    await widget.database.deleteNote(_cattleId, index);
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
    await widget.database.deleteImage(_cattleId, index);
    if (!mounted) {
      return;
    }
    setState(() {});
    _showSnack(AppLocalizations.of(context)!.photoDeleted);
  }

  Future<void> _confirmDeleteCattle() async {
    final CattleRecord? record = _record;
    if (record == null) {
      return;
    }

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.deleteCattleRecord),
          content: Text(localizations.deleteCattleRecordConfirm(record.id)),
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

    await widget.database.deleteCattle(record.id);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(AppLocalizations.of(context)!.cattleRecordDeleted);
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 15, color: Colors.black54),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStatusRow({
    required IconData icon,
    required String label,
    required String status,
    required Color bgColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 15, color: Colors.black54),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthBgColor(String status) {
    switch (status) {
      case 'Healthy':
        return const Color(0xFFE8F5E9);
      case 'Under Observation':
        return const Color(0xFFFFF3E0);
      case 'Diseased':
        return const Color(0xFFFFEBEE);
      case 'Recovered':
        return const Color(0xFFE0F2F1);
      default:
        return const Color(0xFFEEEEEE);
    }
  }

  Color _getHealthTextColor(String status) {
    switch (status) {
      case 'Healthy':
        return const Color(0xFF2E7D32);
      case 'Under Observation':
        return const Color(0xFFE65100);
      case 'Diseased':
        return const Color(0xFFC62828);
      case 'Recovered':
        return const Color(0xFF00695C);
      default:
        return const Color(0xFF424242);
    }
  }

  Color _getVaxBgColor(String status) {
    switch (status) {
      case 'Up to Date':
        return const Color(0xFFE8F5E9);
      case 'Due Soon':
        return const Color(0xFFFFF8E1);
      case 'Overdue':
        return const Color(0xFFFFEBEE);
      case 'No Record':
      default:
        return const Color(0xFFEEEEEE);
    }
  }

  Color _getVaxTextColor(String status) {
    switch (status) {
      case 'Up to Date':
        return const Color(0xFF2E7D32);
      case 'Due Soon':
        return const Color(0xFFF57F17);
      case 'Overdue':
        return const Color(0xFFC62828);
      case 'No Record':
      default:
        return const Color(0xFF424242);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CattleRecord? record = _record;
    final localizations = AppLocalizations.of(context)!;
    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: Text(localizations.cattleDetails)),
        body: Center(child: Text(localizations.cattleNotFound)),
      );
    }

    final bool isFemale = record.effectiveSex == 'Female';

    return DefaultTabController(
      length: isFemale ? 4 : 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            localizations.detailsHeader(record.id),
            style: const TextStyle(
              color: Color(0xFF2D6A4F),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF2D6A4F)),
          actions: <Widget>[
            IconButton(
              onPressed: _showBasicInfoDialog,
              icon: const Icon(Icons.edit, color: Color(0xFF2D6A4F)),
            ),
            IconButton(
              onPressed: _confirmDeleteCattle,
              icon: const Icon(Icons.delete_outline, color: Color(0xFF2D6A4F)),
            ),
          ],
          bottom: TabBar(
            isScrollable: isFemale,
            labelColor: const Color(0xFF2D6A4F),
            unselectedLabelColor: Colors.black87,
            indicatorColor: const Color(0xFF2D6A4F),
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            tabs: <Widget>[
              Tab(text: localizations.tabOverview),
              Tab(text: localizations.tabMedical),
              if (isFemale) const Tab(text: 'Milk Production'),
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
                // 1. Basic Information Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Card Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              localizations.basicInfo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D6A4F),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: Colors.black87),
                              onPressed: _showBasicInfoDialog,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Card Body
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Left side: Cattle ID + Profile Image
                            SizedBox(
                              width: 105,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Icon(
                                          Icons.tag,
                                          size: 13,
                                          color: Color(0xFF2D6A4F),
                                        ),
                                        const SizedBox(width: 3),
                                        Flexible(
                                          child: Text(
                                            record.id,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF2D6A4F),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 140,
                                    width: 105,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: record.profileImagePath == null
                                          ? _imageOrPlaceholder(null, size: 105)
                                          : GestureDetector(
                                              onTap: () => _showFullScreenImage(record.profileImagePath!),
                                              child: _imageOrPlaceholder(
                                                record.profileImagePath,
                                                size: 105,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Right column rows
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  _buildDetailRow(
                                    icon: Icons.calendar_today_outlined,
                                    label: 'Registered On',
                                    value: _formatDate(record.registrationDate),
                                  ),
                                  const Divider(height: 8, thickness: 0.8, color: Color(0xFFEEEEEE)),
                                  _buildDetailRow(
                                    icon: record.effectiveSex == 'Female'
                                        ? Icons.female
                                        : (record.effectiveSex == 'Male' ? Icons.male : Icons.transgender),
                                    label: 'Sex',
                                    value: record.effectiveSex,
                                  ),
                                  const Divider(height: 8, thickness: 0.8, color: Color(0xFFEEEEEE)),
                                  _buildDetailRow(
                                    icon: Icons.cake_outlined,
                                    label: 'Age',
                                    value: record.ageDisplay,
                                  ),
                                  const Divider(height: 8, thickness: 0.8, color: Color(0xFFEEEEEE)),
                                  _buildDetailRow(
                                    icon: Icons.layers_outlined,
                                    label: 'Life Stage',
                                    value: record.effectiveLifeStage,
                                  ),
                                  if (record.effectiveSex == 'Female') ...<Widget>[
                                    const Divider(height: 8, thickness: 0.8, color: Color(0xFFEEEEEE)),
                                    _buildDetailRow(
                                      icon: Icons.pregnant_woman_outlined,
                                      label: 'Status',
                                      value: record.effectiveReproductiveStatus,
                                    ),
                                  ],
                                  const Divider(height: 8, thickness: 0.8, color: Color(0xFFEEEEEE)),
                                  _buildDetailStatusRow(
                                    icon: Icons.favorite_border,
                                    label: 'Health Status',
                                    status: record.effectiveHealthStatus,
                                    bgColor: _getHealthBgColor(record.effectiveHealthStatus),
                                    textColor: _getHealthTextColor(record.effectiveHealthStatus),
                                  ),
                                  const Divider(height: 8, thickness: 0.8, color: Color(0xFFEEEEEE)),
                                  _buildDetailStatusRow(
                                    icon: Icons.vaccines_outlined,
                                    label: 'Vaccination Status',
                                    status: record.calculatedVaccinationStatus,
                                    bgColor: _getVaxBgColor(record.calculatedVaccinationStatus),
                                    textColor: _getVaxTextColor(record.calculatedVaccinationStatus),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Breed Classification Card
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(top: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          localizations.breedClassification,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D6A4F),
                          ),
                        ),
                        if (record.displayBreed == null) ...<Widget>[
                          const SizedBox(height: 4),
                          Text(
                            'Take a full-body photo to classify breed',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F2),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFE2EBE5), width: 1.5),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.pets,
                                  color: Color(0xFF2D6A4F),
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    record.breedConfirmedByUser
                                        ? 'Confirmed Breed'
                                        : (record.displayBreed != null ? 'Predicted Breed' : 'Breed'),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    record.displayBreed ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: _classifyBreed,
                              icon: const Icon(Icons.sync, size: 16, color: Color(0xFF2D6A4F)),
                              label: Text(
                                record.displayBreed == null
                                    ? localizations.classifyBreed
                                    : localizations.reClassify,
                                style: const TextStyle(
                                  color: Color(0xFF2D6A4F),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF2D6A4F)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              ),
                            ),
                          ],
                        ),

                        // Suggestions / manual override if not confirmed
                        if (!record.breedConfirmedByUser &&
                            record.breedAlternativesJson != null)
                          Builder(
                            builder: (BuildContext context) {
                              final List<BreedPrediction> alternatives = _parseAlternatives(
                                record.breedAlternativesJson,
                              );
                              final double topConfidence = record.breedConfidence ??
                                  (alternatives.isNotEmpty ? alternatives.first.confidence : 0.0);

                              if (topConfidence < 0.60) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 12),
                                    Text(
                                      localizations.lowConfidenceWarning,
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
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
                                          child: const Text('Set as Unknown'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(height: 12),
                                  Text(localizations.likelyBreedsVisual),
                                  const SizedBox(height: 6),
                                  ...alternatives.take(3).map((BreedPrediction p) {
                                    final int percent = (p.confidence * 100).round();
                                    return Text('• ${p.name} — $percent%');
                                  }),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: <Widget>[
                                      if (alternatives.isNotEmpty)
                                        FilledButton(
                                          onPressed: () => _confirmBreed(alternatives.first.name),
                                          child: Text(localizations.confirmBreed(alternatives.first.name)),
                                        ),
                                      OutlinedButton(
                                        onPressed: _chooseDifferentBreed,
                                        child: Text(localizations.chooseDifferent),
                                      ),
                                      OutlinedButton(
                                        onPressed: _setUnknownBreed,
                                        child: const Text('Set as Unknown'),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
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
      if (isFemale)
        _buildMilkProductionTab(record),
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
            title: localizations.cattleIdentification,
            buttonLabel: localizations.addFacialPhoto,
            onAdd: _addIdentityPhoto,
            buttonEnabled: !_isBusy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(localizations.cattleIdentificationDesc),
                if (_isBusy) ...<Widget>[
                  const SizedBox(height: 10),
                  const LinearProgressIndicator(),
                ],
                const SizedBox(height: 10),
                Builder(builder: (context) {
                  // Identity photos are those linked to an embedding.
                  final identityPaths = record.embeddings
                      .map((e) => e.sourceImagePath)
                      .whereType<String>()
                      .toSet();
                  final identityImages = record.imagesNewestFirst
                      .where((img) => identityPaths.contains(img.path))
                      .toList();
                  if (identityImages.isEmpty && !_isBusy) {
                    return Text(localizations.noIdentityPhotos);
                  }
                  return SizedBox(
                    height: 132,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int displayIndex) {
                        final CattleImage image = identityImages[displayIndex];
                        final int index = record.images.indexWhere(
                          (CattleImage item) => item.path == image.path,
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
                                    child: _imageOrPlaceholder(image.path, size: 100),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.white),
                                    color: const Color(0xFFFFFEFA),
                                    onSelected: (String action) {
                                      if (action == 'edit') {
                                        _replaceImageAt(index);
                                      } else {
                                        _confirmDeleteImage(index);
                                      }
                                    },
                                    itemBuilder: (_) => <PopupMenuEntry<String>>[
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
                      itemCount: identityImages.length,
                    ),
                  );
                }),
              ],
            ),
          ),
          _SectionCard(
            title: localizations.photos,
            buttonLabel: localizations.addPhoto,
            onAdd: _addGalleryPhoto,
            buttonEnabled: !_isBusy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(localizations.photoDesc),
                if (_isBusy) ...<Widget>[
                  const SizedBox(height: 10),
                  const LinearProgressIndicator(),
                ],
                const SizedBox(height: 10),
                Builder(builder: (context) {
                  // Gallery photos are those NOT linked to an embedding.
                  final identityPaths = record.embeddings
                      .map((e) => e.sourceImagePath)
                      .whereType<String>()
                      .toSet();
                  final galleryImages = record.imagesNewestFirst
                      .where((img) => !identityPaths.contains(img.path))
                      .toList();
                  if (galleryImages.isEmpty && !_isBusy) {
                    return Text(localizations.noPhotos);
                  }
                  return SizedBox(
                    height: 132,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int displayIndex) {
                        final CattleImage image = galleryImages[displayIndex];
                        final int index = record.images.indexWhere(
                          (CattleImage item) => item.path == image.path,
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
                                    child: _imageOrPlaceholder(image.path, size: 100),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.white),
                                    color: const Color(0xFFFFFEFA),
                                    onSelected: (String action) {
                                      if (action == 'edit') {
                                        _replaceImageAt(index);
                                      } else {
                                        _confirmDeleteImage(index);
                                      }
                                    },
                                    itemBuilder: (_) => <PopupMenuEntry<String>>[
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
                      itemCount: galleryImages.length,
                    ),
                  );
                }),
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

  Widget _buildChartRangeSelector() {
    final List<String> ranges = <String>['7D', '30D', '90D'];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: ranges.map((String range) {
          final bool isSelected = range == _selectedChartRange;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChartRange = range;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2D6A4F) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  range,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMilkProductionTab(CattleRecord record) {
    final MilkAnalyticsService analytics = MilkAnalyticsService(database: widget.database);
    final CattleMilkStats stats = analytics.getStatsForCattle(record.id);
    final List<MilkRecord> records = widget.database.getMilkRecordsForCattle(record.id)
      ..sort((MilkRecord a, MilkRecord b) => b.date.compareTo(a.date));

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    int trendDays = 30;
    if (_selectedChartRange == '7D') {
      trendDays = 7;
    } else if (_selectedChartRange == '30D') {
      trendDays = 30;
    } else if (_selectedChartRange == '90D') {
      trendDays = 90;
    }

    final List<MapEntry<DateTime, double>> dailyTrends = <MapEntry<DateTime, double>>[];
    for (int i = trendDays - 1; i >= 0; i--) {
      final DateTime date = today.subtract(Duration(days: i));
      double sum = 0.0;
      for (final MilkRecord r in records) {
        final DateTime rDate = DateTime(r.date.year, r.date.month, r.date.day);
        if (rDate.isAtSameMomentAs(date)) {
          sum += r.totalYield;
        }
      }
      dailyTrends.add(MapEntry<DateTime, double>(date, sum));
    }

    final bool isCalvingOverdue = record.isPregnant &&
        record.expectedCalvingDate != null &&
        record.expectedCalvingDate!.isBefore(today);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        if (isCalvingOverdue) ...<Widget>[
          Card(
            color: const Color(0xFFFFEBEE),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFEF5350)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFC62828), size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Calving Date Overdue',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC62828), fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Expected calving (${_formatDate(record.expectedCalvingDate!)}) has passed. Update calving information or pregnancy status.',
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFFB71C1C)),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showBasicInfoDialog,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFC62828),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Log Calving', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],

        // 1. Lactation Status Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Icon(Icons.water_drop, color: Color(0xFF2D6A4F), size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Lactation Status',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    _lactationBadge(stats.lactationStage),
                  ],
                ),
                const SizedBox(height: 14),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: _infoBox(
                        label: 'Milking',
                        value: stats.isMilking ? 'Yes' : 'No',
                        color: stats.isMilking ? const Color(0xFF2D6A4F) : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _infoBox(
                        label: 'Days in Milk (DIM)',
                        value: stats.daysInMilk != null ? '${stats.daysInMilk} days' : 'N/A',
                        color: const Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _infoBox(
                        label: 'Last Calving',
                        value: record.calvingDate != null ? _formatDate(record.calvingDate!) : 'Not set',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _infoBox(
                        label: 'Pregnant',
                        value: stats.isPregnant ? 'Yes' : 'No',
                        color: stats.isPregnant ? const Color(0xFF8E24AA) : Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (record.inseminationDate != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _infoBox(
                          label: 'Insemination Date',
                          value: _formatDate(record.inseminationDate!),
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _infoBox(
                          label: 'Est. Next Calving',
                          value: stats.expectedCalvingDate != null ? _formatDate(stats.expectedCalvingDate!) : 'N/A',
                          color: const Color(0xFFC2185B),
                        ),
                      ),
                    ],
                  ),
                ],
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('30-Day Average', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(
                          '${stats.average30DayYield.toStringAsFixed(1)} L/day',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D6A4F)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const Text('Total This Month', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(
                          '${stats.monthTotalYield.toStringAsFixed(1)} L',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),



        // 2. Individual Production Trend Line Chart
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Recent Milk Yield Trend',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _buildChartRangeSelector(),
                const SizedBox(height: 14),
                Builder(
                  builder: (BuildContext context) {
                    const List<String> months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                    return MilkLineChart(
                      dataPoints: dailyTrends.map((MapEntry<DateTime, double> e) => e.value).toList(),
                      xLabels: dailyTrends.map((MapEntry<DateTime, double> e) => '${months[e.key.month - 1]} ${e.key.day}').toList(),
                      originalDates: dailyTrends.map((MapEntry<DateTime, double> e) => e.key).toList(),
                      lineColor: const Color(0xFF2D6A4F),
                      height: 150,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 3. Milk Records History & Add Button
        _SectionCard(
          title: 'Daily Milk Records',
          buttonLabel: 'Record Milk',
          onAdd: () async {
            final bool? saved = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => MilkEntryDialog(
                initialCattleId: record.id,
                database: widget.database,
              ),
            );
            if (saved == true && mounted) {
              setState(() {});
            }
          },
          child: records.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No daily milk yields recorded for this cow yet.', style: TextStyle(color: Colors.grey)),
                )
              : Column(
                  children: records.map((MilkRecord r) {
                    final String dStr = '${r.date.day.toString().padLeft(2, '0')}/${r.date.month.toString().padLeft(2, '0')}/${r.date.year}';
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.water_drop_outlined, color: Color(0xFF2D6A4F)),
                      title: Text('$dStr: ${r.totalYield.toStringAsFixed(1)} Liters', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        'Morning: ${r.morningYield.toStringAsFixed(1)} L • Evening: ${r.eveningYield.toStringAsFixed(1)} L'
                        '${r.notes != null ? '\nNote: ${r.notes}' : ''}',
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 18),
                        onSelected: (String action) async {
                          if (action == 'edit') {
                            await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => MilkEntryDialog(
                                initialCattleId: record.id,
                                initialDate: r.date,
                                database: widget.database,
                              ),
                            );
                            setState(() {});
                          } else if (action == 'delete') {
                            await widget.database.deleteMilkRecord(r.id);
                            setState(() {});
                          }
                        },
                        itemBuilder: (_) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem<String>(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _infoBox({required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _lactationBadge(String stage) {
    Color bg;
    Color fg;
    switch (stage) {
      case 'Fresh':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case 'Early':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        break;
      case 'Mid':
        bg = const Color(0xFFF3E5F5);
        fg = const Color(0xFF7B1FA2);
        break;
      case 'Late':
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        break;
      case 'Extended Lactation':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFF57F17);
        break;
      case 'Dry':
      default:
        bg = const Color(0xFFEFEBE9);
        fg = const Color(0xFF5D4037);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$stage Stage',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fg),
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
