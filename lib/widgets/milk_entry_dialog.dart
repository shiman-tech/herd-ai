import 'package:flutter/material.dart';
import '../models/cattle_record.dart';
import '../models/milk_record.dart';
import '../services/embedding_database.dart';

class MilkEntryDialog extends StatefulWidget {
  const MilkEntryDialog({
    super.key,
    this.initialCattleId,
    this.initialDate,
    required this.database,
  });

  final String? initialCattleId;
  final DateTime? initialDate;
  final EmbeddingDatabase database;

  @override
  State<MilkEntryDialog> createState() => _MilkEntryDialogState();
}

class _MilkEntryDialogState extends State<MilkEntryDialog> {
  late String? _selectedCattleId;
  late DateTime _selectedDate;
  final TextEditingController _morningController = TextEditingController();
  final TextEditingController _eveningController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isEditingExisting = false;
  String? _existingRecordId;

  @override
  void initState() {
    super.initState();
    _selectedCattleId = widget.initialCattleId;
    final DateTime now = widget.initialDate ?? DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);

    // If no initial cattle selected, choose the first milking cow or first cow in herd
    final List<CattleRecord> all = widget.database.getAllCattle();
    if (_selectedCattleId == null && all.isNotEmpty) {
      final CattleRecord? firstMilking = all.where((c) => c.isMilking).firstOrNull;
      _selectedCattleId = (firstMilking ?? all.first).id;
    }

    _loadExistingRecordForSelection();
  }

  void _loadExistingRecordForSelection() {
    if (_selectedCattleId == null) return;
    final MilkRecord? existing = widget.database.getMilkRecord(_selectedCattleId!, _selectedDate);
    if (existing != null) {
      _isEditingExisting = true;
      _existingRecordId = existing.id;
      _morningController.text = existing.morningYield.toString();
      _eveningController.text = existing.eveningYield.toString();
      _notesController.text = existing.notes ?? '';
    } else {
      _isEditingExisting = false;
      _existingRecordId = null;
      _morningController.clear();
      _eveningController.clear();
      _notesController.clear();
    }
    setState(() {});
  }

  double get _calculatedTotal {
    final double m = double.tryParse(_morningController.text.trim()) ?? 0.0;
    final double e = double.tryParse(_eveningController.text.trim()) ?? 0.0;
    return m + e;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
      _loadExistingRecordForSelection();
    }
  }

  Future<void> _saveRecord() async {
    if (_selectedCattleId == null || _selectedCattleId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a cattle')),
      );
      return;
    }

    final double morning = double.tryParse(_morningController.text.trim()) ?? 0.0;
    final double evening = double.tryParse(_eveningController.text.trim()) ?? 0.0;
    final String? notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

    final MilkRecord record = MilkRecord(
      id: _existingRecordId ?? 'milk_${_selectedCattleId}_${_selectedDate.millisecondsSinceEpoch}',
      cattleId: _selectedCattleId!,
      date: _selectedDate,
      morningYield: morning,
      eveningYield: evening,
      totalYield: morning + evening,
      notes: notes,
      createdAt: DateTime.now(),
    );

    await widget.database.saveMilkRecord(record);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CattleRecord> allCattle = widget.database.getAllCattle();
    final String dateDisplay = '${_selectedDate.day.toString().padLeft(2, '0')}/'
        '${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';

    return AlertDialog(
      title: Row(
        children: <Widget>[
          const Icon(Icons.water_drop, color: Color(0xFF2D6A4F)),
          const SizedBox(width: 8),
          Text(
            _isEditingExisting ? 'Edit Milk Record' : 'Record Milk Yield',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_isEditingExisting)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade400),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.info_outline, size: 16, color: Colors.amber.shade900),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'A record for this cow on this date already exists. Saving will update it.',
                        style: TextStyle(fontSize: 11.5, color: Colors.amber.shade900, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

            // Cow Selector / Name Display
            if (widget.initialCattleId != null) ...<Widget>[
              const Text(
                'Cattle',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Builder(
                builder: (BuildContext context) {
                  final CattleRecord? c = widget.database.getCattle(widget.initialCattleId!);
                  final String nameDisplay = c != null
                      ? '${c.id} (${c.effectiveBreed})'
                      : widget.initialCattleId!;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.pets, size: 18, color: Color(0xFF2D6A4F)),
                        const SizedBox(width: 8),
                        Text(
                          nameDisplay,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ] else ...<Widget>[
              const Text(
                'Select Cow',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                initialValue: _selectedCattleId,
                isExpanded: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: allCattle.map((CattleRecord c) {
                  return DropdownMenuItem<String>(
                    value: c.id,
                    child: Row(
                      children: <Widget>[
                        Text(c.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text('(${c.effectiveBreed})', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        if (c.isMilking) ...<Widget>[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Milking',
                              style: TextStyle(fontSize: 10, color: Color(0xFF2D6A4F), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? val) {
                  if (val != null) {
                    setState(() {
                      _selectedCattleId = val;
                    });
                    _loadExistingRecordForSelection();
                  }
                },
              ),
            ],
            const SizedBox(height: 12),

            // Date Picker Row
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Record Date',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(dateDisplay, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Morning & Evening Inputs
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Morning (L)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _morningController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          hintText: '0.0',
                          suffixText: 'L',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Evening (L)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _eveningController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          hintText: '0.0',
                          suffixText: 'L',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Total Yield Indicator Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC8E6C9)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total Daily Yield',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D6A4F), fontSize: 13),
                  ),
                  Text(
                    '${_calculatedTotal.toStringAsFixed(1)} Liters',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D6A4F)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Notes
            const Text(
              'Notes (Optional)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'e.g. Fed silage, normal appetite',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              maxLines: 2,
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
          onPressed: _saveRecord,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2D6A4F),
          ),
          child: Text(_isEditingExisting ? 'Update Record' : 'Save Record'),
        ),
      ],
    );
  }
}
