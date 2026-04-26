import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/cow_record.dart';
import '../services/embedding_database.dart';

const Color kFarmPrimary = Color(0xFF2D6A4F);
const Color kFarmSecondary = Color(0xFF95A97F);
const Color kFarmAccent = Color(0xFF8D6E63);

class CowDetailPage extends StatefulWidget {
  const CowDetailPage({super.key, required this.cowId, required this.database});

  final String cowId;
  final EmbeddingDatabase database;

  @override
  State<CowDetailPage> createState() => _CowDetailPageState();
}

class _CowDetailPageState extends State<CowDetailPage> {
  final ImagePicker _picker = ImagePicker();
  late String _cowId;

  @override
  void initState() {
    super.initState();
    _cowId = widget.cowId;
  }

  CowRecord? get _record => widget.database.getCow(_cowId);

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
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
      maxWidth: 1600,
    );
    if (picked == null) {
      return;
    }
    await widget.database.addImage(_cowId, picked.path);
    if (!mounted) {
      return;
    }
    setState(() {});
    _showSnack('Image added');
  }

  Future<void> _replaceImageAt(int index) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
      maxWidth: 1600,
    );
    if (picked == null) {
      return;
    }
    await widget.database.updateImage(
      cowId: _cowId,
      index: index,
      imagePath: picked.path,
    );
    if (!mounted) {
      return;
    }
    setState(() {});
    _showSnack('Image updated');
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
          title: const Text('Delete image'),
          content: const Text('Delete this image from history?'),
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
    _showSnack('Image deleted');
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

    return Scaffold(
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
      ),
      body: ListView(
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
                          ? const DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(0xFFECEEE8),
                              ),
                              child: Icon(Icons.pets),
                            )
                          : Image.file(
                              File(record.profileImagePath!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
            title: 'Images',
            buttonLabel: 'Add Image',
            onAdd: _addImageToHistory,
            child: record.images.isEmpty
                ? const Text('No images in history.')
                : SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(record.images[index]),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
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
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: record.images.length,
                    ),
                  ),
          ),
        ],
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
  });

  final String title;
  final String buttonLabel;
  final VoidCallback onAdd;
  final Widget child;

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
                FilledButton.tonal(
                  onPressed: onAdd,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 38),
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
                  child: Text(buttonLabel),
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
