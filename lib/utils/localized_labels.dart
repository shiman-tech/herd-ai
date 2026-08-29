import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LocalizedLabels {
  LocalizedLabels._();

  static String sex(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value?.toLowerCase()) {
      case 'female':
        return l10n.female;
      case 'male':
        return l10n.male;
      default:
        return l10n.unknown;
    }
  }

  static String lifeStage(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value?.toLowerCase()) {
      case 'calf':
        return l10n.calf;
      case 'heifer':
        return l10n.heifer;
      case 'cow':
        return l10n.cow;
      case 'bull':
        return l10n.bull;
      case 'steer':
        return l10n.steer;
      default:
        return l10n.unknown;
    }
  }

  static String healthStatus(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value?.toLowerCase()) {
      case 'healthy':
        return l10n.healthy;
      case 'under observation':
        return l10n.underObservation;
      case 'diseased':
        return l10n.diseased;
      case 'recovered':
        return l10n.recovered;
      case 'ongoing':
        return l10n.ongoing;
      default:
        return l10n.unknown;
    }
  }

  static String reproductiveStatus(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value?.toLowerCase()) {
      case 'pregnant':
        return l10n.pregnant;
      case 'not pregnant':
        return l10n.notPregnant;
      default:
        return l10n.unknown;
    }
  }

  static String vaccinationStatus(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value?.toLowerCase()) {
      case 'up to date':
        return l10n.upToDate;
      case 'due soon':
        return l10n.dueSoon;
      case 'overdue':
        return l10n.overdue;
      case 'no record':
        return l10n.noRecord;
      default:
        return value ?? l10n.unknown;
    }
  }

  static String milkStatus(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 'Milking Cows':
        return l10n.milkingCows;
      case 'Dry Cows':
        return l10n.dryCows;
      case 'High Producers (>15 L/day)':
        return l10n.highProducers;
      case 'Medium Producers (8–15 L/day)':
        return l10n.mediumProducers;
      case 'Low Producers (<8 L/day)':
        return l10n.lowProducers;
      case 'Recently Calved':
        return l10n.recentlyCalved;
      default:
        return value;
    }
  }

  static String lactationStage(BuildContext context, String stage) {
    final l10n = AppLocalizations.of(context)!;
    switch (stage) {
      case 'Fresh':
        return l10n.freshStage;
      case 'Early':
        return l10n.earlyStage;
      case 'Mid':
        return l10n.midStage;
      case 'Late':
        return l10n.lateStage;
      case 'Extended Lactation':
        return l10n.extendedStage;
      case 'Dry':
        return l10n.dryStage;
      default:
        return stage;
    }
  }

  static String ageDisplay(BuildContext context, DateTime? dob) {
    final l10n = AppLocalizations.of(context)!;
    if (dob == null) {
      return l10n.unknownAge;
    }
    final DateTime now = DateTime.now();
    int months = (now.year - dob.year) * 12 + (now.month - dob.month);
    if (now.day < dob.day) {
      months--;
    }
    months = months >= 0 ? months : 0;
    final int years = months ~/ 12;
    final int remMonths = months % 12;

    if (years > 0 && remMonths > 0) {
      return l10n.yearsMonthsAge(years, years > 1 ? 's' : '', remMonths, remMonths > 1 ? 's' : '');
    } else if (years > 0) {
      return l10n.yearsAge(years, years > 1 ? 's' : '');
    } else {
      return l10n.monthsAge(remMonths, remMonths > 1 ? 's' : '');
    }
  }
}
