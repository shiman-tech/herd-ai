import 'package:flutter/material.dart';
import '../services/embedding_database.dart';
import '../services/milk_analytics_service.dart';
import 'milk_entry_dialog.dart';

class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({
    super.key,
    required this.database,
    this.onOpenCattleDetail,
  });

  final EmbeddingDatabase database;
  final void Function(String cattleId)? onOpenCattleDetail;

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {
  late MilkAnalyticsService _analyticsService;

  @override
  void initState() {
    super.initState();
    _analyticsService = MilkAnalyticsService(database: widget.database);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleAlertAction(MilkAlert alert) async {
    if (alert.type == 'missing_entry') {
      final bool? saved = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => MilkEntryDialog(
          initialCattleId: alert.cattleId,
          initialDate: alert.date,
          database: widget.database,
        ),
      );
      if (saved == true) {
        _refresh();
      }
    } else {
      Navigator.of(context).pop();
      if (widget.onOpenCattleDetail != null) {
        widget.onOpenCattleDetail!(alert.cattleId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<MilkAlert> alerts = _analyticsService.generateSmartAlerts();

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
              Row(
                children: <Widget>[
                  const Icon(Icons.notifications_active_outlined, color: Color(0xFF2D6A4F)),
                  const SizedBox(width: 8),
                  const Text(
                    'Notifications & Smart Alerts',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  if (alerts.isNotEmpty) ...<Widget>[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC62828),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${alerts.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: alerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.check_circle_outline, size: 56, color: Colors.green.shade400),
                        const SizedBox(height: 12),
                        const Text(
                          'All Clear!',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No pending notifications or missing milk records.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: alerts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      final MilkAlert alert = alerts[index];
                      return _buildAlertCard(alert);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(MilkAlert alert) {
    Color cardColor;
    Color borderColor;
    IconData iconData;

    switch (alert.severity) {
      case AlertSeverity.danger:
        cardColor = const Color(0xFFFFEBEE);
        borderColor = const Color(0xFFEF5350);
        iconData = Icons.warning_amber_rounded;
        break;
      case AlertSeverity.warning:
        cardColor = const Color(0xFFFFF8E1);
        borderColor = const Color(0xFFFFCA28);
        iconData = Icons.error_outline;
        break;
      case AlertSeverity.info:
        cardColor = const Color(0xFFE8F5E9);
        borderColor = const Color(0xFF81C784);
        iconData = Icons.edit_note;
        break;
    }

    String actionLabel = 'Take Action';
    if (alert.type == 'missing_entry') {
      actionLabel = 'Record Milk';
    } else if (alert.type == 'calving_overdue' || alert.type == 'calving_reminder') {
      actionLabel = 'Log Calving';
    }

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(iconData, color: borderColor.withValues(alpha: 0.9), size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    alert.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    alert.message,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _handleAlertAction(alert),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(actionLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
