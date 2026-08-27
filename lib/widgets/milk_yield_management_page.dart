import 'package:flutter/material.dart';
import '../models/milk_record.dart';
import '../services/embedding_database.dart';
import '../services/milk_analytics_service.dart';
import 'milk_chart_widgets.dart';
import 'milk_entry_dialog.dart';
import 'milk_reports_sheet.dart';

class MilkYieldManagementPage extends StatefulWidget {
  const MilkYieldManagementPage({
    super.key,
    required this.database,
    this.onOpenCattleDetail,
  });

  final EmbeddingDatabase database;
  final void Function(String cattleId)? onOpenCattleDetail;

  @override
  State<MilkYieldManagementPage> createState() => _MilkYieldManagementPageState();
}

class _MilkYieldManagementPageState extends State<MilkYieldManagementPage> {
  late MilkAnalyticsService _analyticsService;
  String? _selectedBreedFilter;
  String _selectedRange = '30D';

  @override
  void initState() {
    super.initState();
    _analyticsService = MilkAnalyticsService(database: widget.database);
  }

  Future<void> _openMilkEntryDialog([String? cattleId]) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => MilkEntryDialog(
        initialCattleId: cattleId,
        database: widget.database,
      ),
    );
    if (saved == true && mounted) {
      setState(() {});
    }
  }

  void _openReportsSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => MilkReportsSheet(database: widget.database),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HerdMilkSummary summary = _analyticsService.getHerdSummary(breed: _selectedBreedFilter);
    final List<MilkAlert> alerts = _analyticsService.generateSmartAlerts();
    final List<MilkRecord> recentRecords = widget.database.getAllMilkRecords().take(20).toList();

    // Get unique breeds list from database
    final List<String> uniqueBreeds = widget.database
        .getAllCattle()
        .map((c) => c.effectiveBreed)
        .where((b) => b.isNotEmpty)
        .toSet()
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: <Widget>[
          // Breed Selector Dropdown (Filters all analytics stats and charts on this page)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Breed Analytics Filter:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2D6A4F)),
                ),
                SizedBox(
                  width: 160,
                  height: 38,
                  child: DropdownButtonFormField<String?>(
                    isExpanded: true,
                    initialValue: _selectedBreedFilter,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      hintText: 'All Breeds',
                      hintStyle: const TextStyle(fontSize: 11),
                    ),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All Breeds', style: TextStyle(fontSize: 11)),
                      ),
                      ...uniqueBreeds.map((String b) {
                        return DropdownMenuItem<String?>(
                          value: b,
                          child: Text(b, style: const TextStyle(fontSize: 11)),
                        );
                      }),
                    ],
                    onChanged: (String? val) {
                      setState(() {
                        _selectedBreedFilter = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // 1. Top Action Banner / Quick Stats
          _buildTodayHeroCard(summary),
          const SizedBox(height: 14),

          // 2. Smart Alerts Section
          if (alerts.isNotEmpty) ...<Widget>[
            _buildSmartAlertsSection(alerts),
            const SizedBox(height: 14),
          ],

          // 3. Weekly & Monthly Summary Cards
          _buildPeriodTotalsRow(summary),
          const SizedBox(height: 14),

          // 4. Quick Action Buttons Row
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _openMilkEntryDialog(),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Record Milk'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6A4F),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openReportsSheet,
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18, color: Color(0xFF2D6A4F)),
                  label: const Text('Reports', style: TextStyle(color: Color(0xFF2D6A4F), fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2D6A4F), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 5. Analytics & Trend Charts Card
          _buildAnalyticsCard(),
          const SizedBox(height: 18),

          // 6. Recent Daily Milk Log Feed
          _buildRecentRecordsCard(recentRecords),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTodayHeroCard(HerdMilkSummary summary) {
    return Card(
      elevation: 3,
      shadowColor: const Color(0x1A2D6A4F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: const Color(0xFF2D6A4F),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Icon(Icons.water_drop, color: Colors.white, size: 20),
                    SizedBox(width: 6),
                    Text(
                      "Today's Milk Production",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${summary.todayMilkingCows} cows milked',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Big Yield Display
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(
                  summary.todayTotal.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Liters',
                  style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Text('Average / Cow', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    Text(
                      '${summary.todayAveragePerCow.toStringAsFixed(1)} L',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 22),

            // Top Producer & Lowest Producer row
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.star_rounded, color: Colors.amberAccent, size: 18),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          summary.topProducerToday != null
                              ? 'Top: Cow #${summary.topProducerToday} (${summary.topProducerYield.toStringAsFixed(1)} L)'
                              : 'Top Producer: None yet',
                          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (summary.lowestProducerToday != null)
                  Text(
                    'Low: #${summary.lowestProducerToday} (${summary.lowestProducerYield.toStringAsFixed(1)} L)',
                    style: const TextStyle(color: Colors.white70, fontSize: 11.5),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodTotalsRow(HerdMilkSummary summary) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _periodCard(
            label: 'This Week',
            value: '${summary.thisWeekTotal.toStringAsFixed(1)} L',
            icon: Icons.calendar_view_week_outlined,
            color: const Color(0xFF1565C0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _periodCard(
            label: 'This Month',
            value: '${summary.thisMonthTotal.toStringAsFixed(1)} L',
            icon: Icons.calendar_month_outlined,
            color: const Color(0xFF6A1B9A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _periodCard(
            label: 'Milking Herd',
            value: '${summary.totalMilkingHerdSize} cows',
            icon: Icons.pets_outlined,
            color: const Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _periodCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartAlertsSection(List<MilkAlert> alerts) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.notifications_active_outlined, color: Colors.orange, size: 18),
                const SizedBox(width: 6),
                const Text(
                  'Smart Alerts & Reminders',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${alerts.length}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...alerts.take(3).map((MilkAlert alert) {
              Color bgColor;
              Color iconColor;
              IconData icon;
              if (alert.severity == AlertSeverity.danger) {
                bgColor = const Color(0xFFFFEBEE);
                iconColor = const Color(0xFFC62828);
                icon = Icons.error_outline;
              } else if (alert.severity == AlertSeverity.warning) {
                bgColor = const Color(0xFFFFF3E0);
                iconColor = const Color(0xFFE65100);
                icon = Icons.warning_amber_rounded;
              } else {
                bgColor = const Color(0xFFE3F2FD);
                iconColor = const Color(0xFF1565C0);
                icon = Icons.info_outline;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: iconColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(icon, size: 16, color: iconColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            alert.title,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: iconColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            alert.message,
                            style: const TextStyle(fontSize: 11.5, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    if (alert.type == 'missing_entry')
                      TextButton(
                        onPressed: () => _openMilkEntryDialog(alert.cattleId),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('Enter', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }



  Widget _buildRangeSelector() {
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
          final bool isSelected = range == _selectedRange;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRange = range;
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
                    fontSize: 11,
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

  Widget _buildAnalyticsCard() {
    int trendDays = 30;
    if (_selectedRange == '7D') {
      trendDays = 7;
    } else if (_selectedRange == '30D') {
      trendDays = 30;
    } else if (_selectedRange == '90D') {
      trendDays = 90;
    }

    final List<MapEntry<DateTime, double>> dailyTrends = _analyticsService.getDailyProductionTrend(
      days: trendDays,
      breed: _selectedBreedFilter,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(Icons.show_chart, color: Color(0xFF2D6A4F), size: 20),
                SizedBox(width: 8),
                Text(
                  'Production Analytics',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRangeSelector(),
            const SizedBox(height: 14),

            Builder(
              builder: (BuildContext context) {
                const List<String> months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                return MilkLineChart(
                  dataPoints: dailyTrends.map((MapEntry<DateTime, double> e) => e.value).toList(),
                  xLabels: dailyTrends.map((MapEntry<DateTime, double> e) => '${months[e.key.month - 1]} ${e.key.day}').toList(),
                  originalDates: dailyTrends.map((MapEntry<DateTime, double> e) => e.key).toList(),
                  lineColor: const Color(0xFF2D6A4F),
                  height: 180,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecordsCard(List<MilkRecord> records) {
    // Group records by unique date string (YYYY-MM-DD)
    final Map<String, List<MilkRecord>> groupedMap = <String, List<MilkRecord>>{};
    for (final MilkRecord r in records) {
      final String dateKey = '${r.date.year}-${r.date.month.toString().padLeft(2, '0')}-${r.date.day.toString().padLeft(2, '0')}';
      groupedMap.putIfAbsent(dateKey, () => <MilkRecord>[]).add(r);
    }

    final List<String> sortedDates = groupedMap.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Card(
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
                const Text(
                  'Milk History',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${sortedDates.length} days logged',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (sortedDates.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('No milk records saved yet. Tap "Record Milk" to start.', style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedDates.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.black12),
                itemBuilder: (BuildContext context, int index) {
                  final String dateKey = sortedDates[index];
                  final List<MilkRecord> dayRecords = groupedMap[dateKey] ?? <MilkRecord>[];
                  final DateTime parsedDate = dayRecords.first.date;
                  final String formattedDate = '${parsedDate.day.toString().padLeft(2, '0')}/'
                      '${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';

                  final double totalDayYield = dayRecords.fold(0.0, (sum, r) => sum + r.totalYield);
                  final int cowCount = dayRecords.length;

                  return ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    shape: const Border(),
                    title: Text(
                      formattedDate,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      '$cowCount cow${cowCount == 1 ? '' : 's'} recorded',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${totalDayYield.toStringAsFixed(1)} L',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Color(0xFF2D6A4F),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.expand_more, size: 18),
                      ],
                    ),
                    children: dayRecords.map((MilkRecord record) {
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.only(left: 16.0),
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF2D6A4F).withValues(alpha: 0.1),
                          child: Text(
                            record.cattleId.length > 2 ? record.cattleId.substring(0, 2) : record.cattleId,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF2D6A4F)),
                          ),
                        ),
                        title: Row(
                          children: <Widget>[
                            Text('Cow #${record.cattleId}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const Spacer(),
                            Text('${record.totalYield.toStringAsFixed(1)} L', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2D6A4F))),
                          ],
                        ),
                        subtitle: Text(
                          'M: ${record.morningYield.toStringAsFixed(1)} L • E: ${record.eveningYield.toStringAsFixed(1)} L'
                          '${record.notes != null ? '\nNote: ${record.notes}' : ''}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 16),
                          onSelected: (String action) async {
                            if (action == 'edit') {
                              await _openMilkEntryDialog(record.cattleId);
                            } else if (action == 'delete') {
                              await widget.database.deleteMilkRecord(record.id);
                              setState(() {});
                            }
                          },
                          itemBuilder: (_) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                            const PopupMenuItem<String>(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                        onTap: () {
                          if (widget.onOpenCattleDetail != null) {
                            widget.onOpenCattleDetail!(record.cattleId);
                          }
                        },
                      );
                    }).toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
