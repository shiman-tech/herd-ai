import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/embedding_database.dart';
import '../services/milk_report_service.dart';

class MilkReportsSheet extends StatefulWidget {
  const MilkReportsSheet({
    super.key,
    required this.database,
  });

  final EmbeddingDatabase database;

  @override
  State<MilkReportsSheet> createState() => _MilkReportsSheetState();
}

class _MilkReportsSheetState extends State<MilkReportsSheet> {
  late final MilkReportService _reportService;
  int _reportTypeIndex = 0; // 0 = Daily, 1 = Monthly
  late DateTime _selectedDate;
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _reportService = MilkReportService(database: widget.database);
    final DateTime now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedYear = now.year;
    _selectedMonth = now.month;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  void _exportCsv() {
    String csv;
    if (_reportTypeIndex == 0) {
      csv = _reportService.exportDailyReportCsv(_selectedDate);
    } else {
      csv = _reportService.exportMonthlyReportCsv(_selectedYear, _selectedMonth);
    }

    Clipboard.setData(ClipboardData(text: csv));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV Report copied to clipboard! Ready to paste or export.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const List<String> monthNames = <String>[
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Row(
                children: <Widget>[
                  Icon(Icons.assessment_outlined, color: Color(0xFF2D6A4F)),
                  SizedBox(width: 8),
                  Text(
                    'Milk Production Reports',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Toggle Daily / Monthly
          SegmentedButton<int>(
            segments: const <ButtonSegment<int>>[
              ButtonSegment<int>(value: 0, label: Text('Daily Report'), icon: Icon(Icons.today)),
              ButtonSegment<int>(value: 1, label: Text('Monthly Report'), icon: Icon(Icons.calendar_month)),
            ],
            selected: <int>{_reportTypeIndex},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                _reportTypeIndex = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 16),

          // Date / Month Selector Row
          if (_reportTypeIndex == 0)
            Row(
              children: <Widget>[
                const Text('Report Date: ', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.edit_calendar, size: 16),
                  label: Text(
                    '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          else
            Row(
              children: <Widget>[
                const Text('Month: ', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _selectedMonth,
                  items: List.generate(12, (int i) => i + 1).map((int m) {
                    return DropdownMenuItem<int>(
                      value: m,
                      child: Text(monthNames[m - 1]),
                    );
                  }).toList(),
                  onChanged: (int? m) {
                    if (m != null) setState(() => _selectedMonth = m);
                  },
                ),
                const SizedBox(width: 16),
                const Text('Year: ', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _selectedYear,
                  items: <int>[2024, 2025, 2026, 2027].map((int y) {
                    return DropdownMenuItem<int>(
                      value: y,
                      child: Text(y.toString()),
                    );
                  }).toList(),
                  onChanged: (int? y) {
                    if (y != null) setState(() => _selectedYear = y);
                  },
                ),
              ],
            ),
          const Divider(height: 24),

          // Report Content Preview
          Expanded(
            child: _reportTypeIndex == 0
                ? _buildDailyReportView()
                : _buildMonthlyReportView(),
          ),

          const SizedBox(height: 12),

          // Export / Share Actions
          FilledButton.icon(
            onPressed: _exportCsv,
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Export / Copy as CSV'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2D6A4F),
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReportView() {
    final List<DailyReportItem> items = _reportService.getDailyReport(_selectedDate);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            const Text('No milk records for this date', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final double totalYield = items.fold(0.0, (sum, i) => sum + i.totalYield);

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${items.length} cows milked', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('Total: ${totalYield.toStringAsFixed(1)} L', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D6A4F))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int index) {
              final DailyReportItem item = items[index];
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF2D6A4F).withValues(alpha: 0.1),
                  child: Text(
                    item.cattleId.length > 2 ? item.cattleId.substring(0, 2) : item.cattleId,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2D6A4F)),
                  ),
                ),
                title: Text('Cow #${item.cattleId}', style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('Morning: ${item.morningYield.toStringAsFixed(1)} L • Evening: ${item.eveningYield.toStringAsFixed(1)} L'),
                trailing: Text(
                  '${item.totalYield.toStringAsFixed(1)} L',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyReportView() {
    final MonthlyReportSummary summary = _reportService.getMonthlyReportSummary(_selectedYear, _selectedMonth);

    if (summary.totalYield == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            const Text('No milk records for this month', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Summary KPI Cards
          Row(
            children: <Widget>[
              Expanded(
                child: _summaryTile('Total Yield', '${summary.totalYield.toStringAsFixed(1)} L', Icons.water_drop, const Color(0xFF2D6A4F)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _summaryTile('Daily Avg', '${summary.averageDailyYield.toStringAsFixed(1)} L/day', Icons.speed, Colors.blue.shade700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _summaryTile(
                  'Top Cow',
                  summary.bestProducingCow != null ? 'Cow #${summary.bestProducingCow}\n(${summary.bestProducingCowYield.toStringAsFixed(1)} L)' : 'N/A',
                  Icons.emoji_events,
                  Colors.amber.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _summaryTile(
                  'Lowest Cow',
                  summary.lowestProducingCow != null ? 'Cow #${summary.lowestProducingCow}\n(${summary.lowestProducingCowYield.toStringAsFixed(1)} L)' : 'N/A',
                  Icons.trending_down,
                  Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey.shade900),
          ),
        ],
      ),
    );
  }
}
