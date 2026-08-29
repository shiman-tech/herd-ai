import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/milk_analytics_service.dart';

class LocalizedAlerts {
  static String getTitle(BuildContext context, MilkAlert alert) {
    final l10n = AppLocalizations.of(context)!;
    switch (alert.type) {
      case 'missing_entry':
        if (alert.id.contains('today')) {
          return l10n.missingMilkEntryToday;
        } else if (alert.date != null) {
          return l10n.missingMilkEntryTitle('${alert.date!.day}/${alert.date!.month}');
        }
        return l10n.missingMilkEntryToday;
      case 'low_yield':
        return l10n.lowYieldAlertTitle;
      case 'dry_off_reminder':
        return l10n.dryOffReminderTitle;
      case 'calving_overdue':
        return l10n.calvingDateOverdueTitle;
      case 'calving_reminder':
        return l10n.calvingReminderTitle;
      case 'vaccination_overdue':
        return l10n.vaccinationOverdueTitle;
      case 'vaccination_due':
        return l10n.vaccinationDueSoonTitle;
      default:
        return alert.title;
    }
  }

  static String getMessage(BuildContext context, MilkAlert alert) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (alert.type) {
      case 'missing_entry':
        final parts = alert.id.split('_');
        if (parts.length >= 6) {
          final year = int.tryParse(parts[parts.length - 3]);
          final month = int.tryParse(parts[parts.length - 2]);
          final day = int.tryParse(parts[parts.length - 1]);
          if (year != null && month != null && day != null) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final checkDate = DateTime(year, month, day);
            final diff = today.difference(checkDate).inDays;
            
            String dateLabel;
            if (diff == 0) {
              dateLabel = l10n.today;
            } else if (diff == 1) {
              dateLabel = l10n.yesterday;
            } else {
              dateLabel = l10n.onDate('$day/$month/$year');
            }
            return l10n.noMilkRecordEntered(dateLabel, alert.cattleId);
          }
        }
        return alert.message;

      case 'low_yield':
        final regExp = RegExp(r'dropped\s+(\d+)%\s+\((\d+\.\d+)\s*L\s+vs\s+(\d+\.\d+)\s*L\s+avg\)');
        final match = regExp.firstMatch(alert.message);
        if (match != null) {
          final percent = match.group(1) ?? '0';
          final latest = match.group(2) ?? '0.0';
          final avg = match.group(3) ?? '0.0';
          return l10n.lowYieldAlertMessage(alert.cattleId, percent, latest, avg);
        }
        return alert.message;

      case 'dry_off_reminder':
        final regExp = RegExp(r'calve\s+in\s+(\d+)\s+days');
        final match = regExp.firstMatch(alert.message);
        if (match != null) {
          final days = int.tryParse(match.group(1) ?? '0') ?? 0;
          return l10n.dryOffReminderMessage(alert.cattleId, days);
        }
        return alert.message;

      case 'calving_overdue':
        final regExp = RegExp(r'was\s+(\d+)\s+days?\s+ago\s+\((.*?)\)');
        final match = regExp.firstMatch(alert.message);
        if (match != null) {
          final days = int.tryParse(match.group(1) ?? '0') ?? 0;
          final dateStr = match.group(2) ?? '';
          return l10n.calvingDateOverdueMessage(alert.cattleId, days, days == 1 ? '' : 's', dateStr);
        }
        return alert.message;

      case 'calving_reminder':
        final regExp = RegExp(r'calving\s+in\s+(\d+)\s+days?');
        final match = regExp.firstMatch(alert.message);
        if (match != null) {
          final days = int.tryParse(match.group(1) ?? '0') ?? 0;
          return l10n.calvingReminderMessage(alert.cattleId, days, days == 1 ? '' : 's');
        }
        return alert.message;

      case 'vaccination_overdue':
        final regExp = RegExp(r'—\s+(.*?)\s+was\s+due\s+(\d+)\s+days?\s+ago\s+\((.*?)\)');
        final match = regExp.firstMatch(alert.message);
        if (match != null) {
          final vacName = match.group(1) ?? 'Vaccine';
          final days = int.tryParse(match.group(2) ?? '0') ?? 0;
          final dateStr = match.group(3) ?? '';
          return l10n.vaccinationOverdueMessage(alert.cattleId, vacName, days, days == 1 ? '' : 's', dateStr);
        }
        return alert.message;

      case 'vaccination_due':
        final regExp = RegExp(r'—\s+(.*?)\s+due\s+in\s+(\d+)\s+days?\s+\((.*?)\)');
        final match = regExp.firstMatch(alert.message);
        if (match != null) {
          final vacName = match.group(1) ?? 'Vaccine';
          final days = int.tryParse(match.group(2) ?? '0') ?? 0;
          final dateStr = match.group(3) ?? '';
          return l10n.vaccinationDueSoonMessage(alert.cattleId, vacName, days, days == 1 ? '' : 's', dateStr);
        }
        return alert.message;

      default:
        return alert.message;
    }
  }
}
