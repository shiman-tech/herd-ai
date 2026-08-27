import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/embedding_database.dart';
import '../services/milk_report_service.dart';

class MilkReportsSheet extends StatefulWidget {
  const MilkReportsSheet({
    super.key,
    required this.database,
    this.breed,
  });

  final EmbeddingDatabase database;
  final String? breed;

  @override
  State<MilkReportsSheet> createState() => _MilkReportsSheetState();
}

class _MilkReportsSheetState extends State<MilkReportsSheet> {
  late final MilkReportService _reportService;
  int _reportTypeIndex = 0; // 0 = Daily, 1 = Weekly, 2 = Monthly
  late DateTime _selectedDate; // Daily date
  late DateTime _selectedWeekStart; // Weekly start date
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _reportService = MilkReportService(database: widget.database);
    final DateTime now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedWeekStart = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
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

  Future<void> _pickWeekStart() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedWeekStart,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedWeekStart = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  void _exportCsv() {
    String csv;
    if (_reportTypeIndex == 0) {
      csv = _reportService.exportDailyReportCsv(_selectedDate, breed: widget.breed);
    } else if (_reportTypeIndex == 1) {
      csv = _reportService.exportWeeklyReportCsv(_selectedWeekStart, breed: widget.breed);
    } else {
      csv = _reportService.exportMonthlyReportCsv(_selectedYear, _selectedMonth, breed: widget.breed);
    }

    Clipboard.setData(ClipboardData(text: csv));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV ${_getReportTypeName()} Report copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getReportTypeName() {
    if (_reportTypeIndex == 0) return 'Daily';
    if (_reportTypeIndex == 1) return 'Weekly';
    return 'Monthly';
  }

  @override
  Widget build(BuildContext context) {
    const List<String> monthNames = <String>[
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final String breedLabel = widget.breed ?? 'All Breeds';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
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
              Expanded(
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.assessment_outlined, color: Color(0xFF2D6A4F)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Milk Production Reports',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          
          // Breed indicator badge
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D6A4F).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2D6A4F).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.filter_alt, size: 13, color: Color(0xFF2D6A4F)),
                    const SizedBox(width: 4),
                    Text(
                      'Breed Filter: $breedLabel',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D6A4F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Segmented Toggle: Daily / Weekly / Monthly
          SegmentedButton<int>(
            segments: const <ButtonSegment<int>>[
              ButtonSegment<int>(value: 0, label: Text('Daily'), icon: Icon(Icons.today, size: 16)),
              ButtonSegment<int>(value: 1, label: Text('Weekly'), icon: Icon(Icons.view_week, size: 16)),
              ButtonSegment<int>(value: 2, label: Text('Monthly'), icon: Icon(Icons.calendar_month, size: 16)),
            ],
            selected: <int>{_reportTypeIndex},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                _reportTypeIndex = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 16),

          // Date / Week / Month Selector Row
          if (_reportTypeIndex == 0) ...<Widget>[
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
            ),
          ] else if (_reportTypeIndex == 1) ...<Widget>[
            Row(
              children: <Widget>[
                const Text('Week Start: ', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _pickWeekStart,
                  icon: const Icon(Icons.edit_calendar, size: 16),
                  label: Text(
                    '${_selectedWeekStart.day.toString().padLeft(2, '0')}/${_selectedWeekStart.month.toString().padLeft(2, '0')}/${_selectedWeekStart.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ] else ...<Widget>[
            Row(
              children: <Widget>[
                DropdownButton<int>(
                  value: _selectedMonth,
                  items: List<DropdownMenuItem<int>>.generate(12, (int i) {
                    return DropdownMenuItem<int>(
                      value: i + 1,
                      child: Text(monthNames[i]),
                    );
                  }),
                  onChanged: (int? m) {
                    if (m != null) setState(() => _selectedMonth = m);
                  },
                ),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _selectedYear,
                  items: List<DropdownMenuItem<int>>.generate(5, (int i) {
                    final int y = DateTime.now().year - i;
                    return DropdownMenuItem<int>(value: y, child: Text('$y'));
                  }),
                  onChanged: (int? y) {
                    if (y != null) setState(() => _selectedYear = y);
                  },
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),

          // Report Content Body
          Expanded(
            child: _reportTypeIndex == 0
                ? _buildDailyReportView()
                : (_reportTypeIndex == 1
                    ? _buildWeeklyReportView()
                    : _buildMonthlyReportView(monthNames[_selectedMonth - 1])),
          ),

          const SizedBox(height: 12),

          // Export Button
          FilledButton.icon(
            onPressed: _exportCsv,
            icon: const Icon(Icons.copy),
            label: Text('Copy ${_getReportTypeName()} CSV Report'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2D6A4F),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReportView() {
    final List<DailyReportItem> items = _reportService.getDailyReport(_selectedDate, breed: widget.breed);

    if (items.isEmpty) {
      return _emptyReportState();
    }

    final double total = items.fold(0.0, (double sum, DailyReportItem item) => sum + item.totalYield);
    final String bestCow = items.first.cattleId;
    final double bestYield = items.first.totalYield;
    final String worstCow = items.last.cattleId;
    final double worstYield = items.last.totalYield;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildHerdPerformanceCard(
          totalYield: total,
          avgYield: total / items.length,
          bestCow: bestCow,
          bestYield: bestYield,
          worstCow: worstCow,
          worstYield: worstYield,
          cowCount: items.length,
        ),
        const SizedBox(height: 12),
        const Text(
          'Ranked Performance (Best → Lowest Daily Yield)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int i) {
              final DailyReportItem item = items[i];
              return _buildRankItem(
                rank: i + 1,
                cattleId: item.cattleId,
                totalYield: item.totalYield,
                detailText: 'Morning: ${item.morningYield.toStringAsFixed(1)} L  •  Evening: ${item.eveningYield.toStringAsFixed(1)} L',
                isBest: i == 0,
                isWorst: i == items.length - 1 && items.length > 1,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyReportView() {
    final WeeklyReportSummary summary = _reportService.getWeeklyReportSummary(_selectedWeekStart, breed: widget.breed);
    final String startStr = '${summary.startDate.day}/${summary.startDate.month}/${summary.startDate.year}';
    final String endStr = '${summary.endDate.day}/${summary.endDate.month}/${summary.endDate.year}';

    if (summary.rankedCows.isEmpty) {
      return _emptyReportState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildHerdPerformanceCard(
          totalYield: summary.totalYield,
          avgYield: summary.averageDailyYield,
          bestCow: summary.bestProducingCow,
          bestYield: summary.bestProducingCowYield,
          worstCow: summary.lowestProducingCow,
          worstYield: summary.lowestProducingCowYield,
          cowCount: summary.activeMilkingCowsCount,
          periodLabel: 'Weekly Total\n($startStr - $endStr)',
          avgLabel: 'Daily Avg',
        ),
        const SizedBox(height: 12),
        const Text(
          'Ranked Performance (Best → Lowest Weekly Total)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.separated(
            itemCount: summary.rankedCows.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int i) {
              final CowPerformanceItem item = summary.rankedCows[i];
              return _buildRankItem(
                rank: i + 1,
                cattleId: item.cattleId,
                totalYield: item.totalYield,
                detailText: 'Recorded: ${item.daysRecorded}/7 days  •  Avg: ${item.averageDailyYield.toStringAsFixed(1)} L/day',
                isBest: i == 0,
                isWorst: i == summary.rankedCows.length - 1 && summary.rankedCows.length > 1,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyReportView(String monthName) {
    final MonthlyReportSummary summary = _reportService.getMonthlyReportSummary(_selectedYear, _selectedMonth, breed: widget.breed);

    if (summary.rankedCows.isEmpty) {
      return _emptyReportState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildHerdPerformanceCard(
          totalYield: summary.totalYield,
          avgYield: summary.averageDailyYield,
          bestCow: summary.bestProducingCow,
          bestYield: summary.bestProducingCowYield,
          worstCow: summary.lowestProducingCow,
          worstYield: summary.lowestProducingCowYield,
          cowCount: summary.activeMilkingCowsCount,
          periodLabel: 'Monthly Total',
          avgLabel: 'Daily Avg',
        ),
        const SizedBox(height: 12),
        const Text(
          'Ranked Performance (Best → Lowest Monthly Total)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.separated(
            itemCount: summary.rankedCows.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int i) {
              final CowPerformanceItem item = summary.rankedCows[i];
              return _buildRankItem(
                rank: i + 1,
                cattleId: item.cattleId,
                totalYield: item.totalYield,
                detailText: 'Recorded: ${item.daysRecorded} entries  •  Avg: ${item.averageDailyYield.toStringAsFixed(1)} L/day',
                isBest: i == 0,
                isWorst: i == summary.rankedCows.length - 1 && summary.rankedCows.length > 1,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHerdPerformanceCard({
    required double totalYield,
    required double avgYield,
    required String? bestCow,
    required double bestYield,
    required String? worstCow,
    required double worstYield,
    required int cowCount,
    String periodLabel = 'Herd Total',
    String avgLabel = 'Daily Avg',
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: const Color(0xFF2D6A4F).withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFF2D6A4F).withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _summaryTile(periodLabel, '${totalYield.toStringAsFixed(1)} L'),
                ),
                Expanded(
                  child: _summaryTile(avgLabel, '${avgYield.toStringAsFixed(1)} L/cow'),
                ),
                Expanded(
                  child: _summaryTile('Total Herd Size', '$cowCount cows'),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1, color: Colors.black12),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('Best Cow', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            Text(
                              bestCow != null ? 'Cow #$bestCow (${bestYield.toStringAsFixed(1)} L)' : 'N/A',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.trending_down, color: Colors.red.shade400, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('Worst Cow', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            Text(
                              worstCow != null ? 'Cow #$worstCow (${worstYield.toStringAsFixed(1)} L)' : 'N/A',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red.shade600),
                            ),
                          ],
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

  Widget _summaryTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRankItem({
    required int rank,
    required String cattleId,
    required double totalYield,
    required String detailText,
    required bool isBest,
    required bool isWorst,
  }) {
    Color rankBgColor = Colors.grey.shade100;
    Color rankTextColor = Colors.grey.shade800;

    if (isBest) {
      rankBgColor = const Color(0xFFE8F5E9);
      rankTextColor = const Color(0xFF2D6A4F);
    } else if (isWorst) {
      rankBgColor = const Color(0xFFFFEBEE);
      rankTextColor = const Color(0xFFC62828);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rankBgColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '#$rank',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: rankTextColor),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Cow #$cattleId',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                Text(
                  detailText,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            '${totalYield.toStringAsFixed(1)} L',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
              color: isBest ? const Color(0xFF2D6A4F) : (isWorst ? const Color(0xFFC62828) : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyReportState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.notes_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'No milk records found for this period${widget.breed != null ? " ($widget.breed)" : ""}.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
