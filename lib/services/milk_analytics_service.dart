import '../models/cattle_record.dart';
import '../models/milk_record.dart';
import 'embedding_database.dart';

enum AlertSeverity { info, warning, danger }

class MilkAlert {
  const MilkAlert({
    required this.id,
    required this.cattleId,
    required this.title,
    required this.message,
    required this.severity,
    required this.type,
    this.date,
  });

  final String id;
  final String cattleId;
  final String title;
  final String message;
  final AlertSeverity severity;
  final String type; // 'low_yield', 'missing_entry', 'dry_off_reminder', 'calving_reminder'
  final DateTime? date;
}

class HerdMilkSummary {
  const HerdMilkSummary({
    required this.todayTotal,
    required this.todayMilkingCows,
    required this.todayAveragePerCow,
    required this.topProducerToday,
    required this.topProducerYield,
    required this.lowestProducerToday,
    required this.lowestProducerYield,
    required this.thisWeekTotal,
    required this.thisMonthTotal,
    required this.totalMilkingHerdSize,
  });

  final double todayTotal;
  final int todayMilkingCows;
  final double todayAveragePerCow;
  final String? topProducerToday;
  final double topProducerYield;
  final String? lowestProducerToday;
  final double lowestProducerYield;
  final double thisWeekTotal;
  final double thisMonthTotal;
  final int totalMilkingHerdSize;
}

class CattleMilkStats {
  const CattleMilkStats({
    required this.cattleId,
    required this.daysInMilk,
    required this.lactationStage,
    required this.average30DayYield,
    required this.monthTotalYield,
    required this.lastRecordedYield,
    required this.lastRecordedDate,
    required this.expectedDailyYield,
    required this.isMilking,
    required this.isPregnant,
    required this.expectedCalvingDate,
    required this.targetDryOffDate,
  });

  final String cattleId;
  final int? daysInMilk;
  final String lactationStage;
  final double average30DayYield;
  final double monthTotalYield;
  final double? lastRecordedYield;
  final DateTime? lastRecordedDate;
  final double? expectedDailyYield;
  final bool isMilking;
  final bool isPregnant;
  final DateTime? expectedCalvingDate;
  final DateTime? targetDryOffDate;
}

class MilkAnalyticsService {
  MilkAnalyticsService({EmbeddingDatabase? database})
      : _database = database ?? EmbeddingDatabase.instance;

  final EmbeddingDatabase _database;

  /// Calculate herd-wide dashboard summary statistics
  HerdMilkSummary getHerdSummary({String? breed}) {
    final List<CattleRecord> allCattle = _database.getAllCattle();
    final List<MilkRecord> allRecords = _database.getAllMilkRecords();

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime sevenDaysAgo = today.subtract(const Duration(days: 6));
    final DateTime startOfMonth = DateTime(now.year, now.month, 1);

    // Build fast breed mapping
    final Map<String, String> cattleBreedMap = <String, String>{
      for (final CattleRecord c in allCattle) c.id: c.effectiveBreed
    };

    // Filtered lists by breed if applicable
    final List<MilkRecord> breedRecords = breed == null
        ? allRecords
        : allRecords.where((r) => cattleBreedMap[r.cattleId] == breed).toList();

    final List<CattleRecord> breedCattle = breed == null
        ? allCattle
        : allCattle.where((c) => c.effectiveBreed == breed).toList();

    // Records for today
    final List<MilkRecord> todayRecords = breedRecords.where((MilkRecord r) {
      final DateTime d = DateTime(r.date.year, r.date.month, r.date.day);
      return d.isAtSameMomentAs(today);
    }).toList();

    double todayTotal = 0.0;
    String? topCow;
    double topYield = -1;
    String? lowCow;
    double lowYield = double.infinity;

    for (final MilkRecord r in todayRecords) {
      todayTotal += r.totalYield;
      if (r.totalYield > topYield) {
        topYield = r.totalYield;
        topCow = r.cattleId;
      }
      if (r.totalYield < lowYield) {
        lowYield = r.totalYield;
        lowCow = r.cattleId;
      }
    }

    final int todayMilkingCows = todayRecords.length;
    final double todayAvg = todayMilkingCows > 0 ? (todayTotal / todayMilkingCows) : 0.0;

    // Weekly total
    double weekTotal = 0.0;
    for (final MilkRecord r in breedRecords) {
      final DateTime d = DateTime(r.date.year, r.date.month, r.date.day);
      if (!d.isBefore(sevenDaysAgo) && !d.isAfter(today)) {
        weekTotal += r.totalYield;
      }
    }

    // Monthly total
    double monthTotal = 0.0;
    for (final MilkRecord r in breedRecords) {
      final DateTime d = DateTime(r.date.year, r.date.month, r.date.day);
      if (!d.isBefore(startOfMonth) && !d.isAfter(today)) {
        monthTotal += r.totalYield;
      }
    }

    final int totalMilkingHerd = breedCattle.where((CattleRecord c) => c.isMilking).length;

    return HerdMilkSummary(
      todayTotal: todayTotal,
      todayMilkingCows: todayMilkingCows,
      todayAveragePerCow: todayAvg,
      topProducerToday: topCow,
      topProducerYield: topYield >= 0 ? topYield : 0.0,
      lowestProducerToday: lowCow,
      lowestProducerYield: (lowYield != double.infinity) ? lowYield : 0.0,
      thisWeekTotal: weekTotal,
      thisMonthTotal: monthTotal,
      totalMilkingHerdSize: totalMilkingHerd,
    );
  }

  /// Calculates stats for an individual cow
  CattleMilkStats getStatsForCattle(String cattleId) {
    final CattleRecord? cattle = _database.getCattle(cattleId);
    final List<MilkRecord> records = _database.getMilkRecordsForCattle(cattleId)
      ..sort((MilkRecord a, MilkRecord b) => b.date.compareTo(a.date));

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
    final DateTime startOfMonth = DateTime(now.year, now.month, 1);

    double sum30Days = 0.0;
    int count30Days = 0;
    double monthTotal = 0.0;

    for (final MilkRecord r in records) {
      final DateTime d = DateTime(r.date.year, r.date.month, r.date.day);
      if (!d.isBefore(thirtyDaysAgo) && !d.isAfter(today)) {
        sum30Days += r.totalYield;
        count30Days++;
      }
      if (!d.isBefore(startOfMonth) && !d.isAfter(today)) {
        monthTotal += r.totalYield;
      }
    }

    final double avg30Day = count30Days > 0 ? (sum30Days / count30Days) : 0.0;
    final MilkRecord? latest = records.isNotEmpty ? records.first : null;

    return CattleMilkStats(
      cattleId: cattleId,
      daysInMilk: cattle?.daysInMilk,
      lactationStage: cattle?.lactationStage ?? 'Dry',
      average30DayYield: avg30Day,
      monthTotalYield: monthTotal,
      lastRecordedYield: latest?.totalYield,
      lastRecordedDate: latest?.date,
      expectedDailyYield: cattle?.expectedDailyYield,
      isMilking: cattle?.isMilking ?? false,
      isPregnant: cattle?.isPregnant ?? false,
      expectedCalvingDate: cattle?.expectedCalvingDate,
      targetDryOffDate: cattle?.targetDryOffDate,
    );
  }

  /// Generates real-time Smart Alerts
  List<MilkAlert> generateSmartAlerts() {
    final List<MilkAlert> alerts = <MilkAlert>[];
    final List<CattleRecord> allCattle = _database.getAllCattle();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    for (final CattleRecord cattle in allCattle) {
      final List<MilkRecord> records = _database.getMilkRecordsForCattle(cattle.id)
        ..sort((MilkRecord a, MilkRecord b) => b.date.compareTo(a.date));

      // 1. Missing Entry Alerts — only from the day of the FIRST milk record
      if (cattle.isMilking && records.isNotEmpty) {
        // The earliest recorded date is the start of milking tracking
        final DateTime earliestRecord = records.reduce(
          (MilkRecord a, MilkRecord b) => a.date.isBefore(b.date) ? a : b,
        ).date;
        final DateTime milkingStartDate = DateTime(
          earliestRecord.year, earliestRecord.month, earliestRecord.day,
        );

        for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
          final DateTime checkDate = today.subtract(Duration(days: dayOffset));

          // Don't alert for days before milking started
          if (checkDate.isBefore(milkingStartDate)) {
            break;
          }

          final bool hasRecord = records.any((MilkRecord r) {
            final DateTime d = DateTime(r.date.year, r.date.month, r.date.day);
            return d.isAtSameMomentAs(checkDate);
          });

          if (!hasRecord) {
            final String dateLabel = dayOffset == 0
                ? 'today'
                : (dayOffset == 1
                    ? 'yesterday'
                    : 'on ${checkDate.day}/${checkDate.month}/${checkDate.year}');
            alerts.add(MilkAlert(
              id: 'missing_entry_${cattle.id}_${checkDate.year}_${checkDate.month}_${checkDate.day}',
              cattleId: cattle.id,
              title: dayOffset == 0 ? 'Missing Milk Entry Today' : 'Missing Milk Entry (${checkDate.day}/${checkDate.month})',
              message: 'No milk record entered $dateLabel for #${cattle.id}.',
              severity: dayOffset <= 1 ? AlertSeverity.info : AlertSeverity.warning,
              type: 'missing_entry',
              date: checkDate,
            ));
          }
        }
      }

      // 2. Low Yield Alert (Current yield < 70% of 30-day average)
      if (records.isNotEmpty) {
        final MilkRecord latest = records.first;
        final DateTime latestDate = DateTime(latest.date.year, latest.date.month, latest.date.day);
        
        // Only evaluate if latest record was recent (within last 3 days)
        if (today.difference(latestDate).inDays <= 3) {
          double sumPast = 0.0;
          int countPast = 0;
          final DateTime thirtyDaysBeforeLatest = latestDate.subtract(const Duration(days: 30));

          for (final MilkRecord r in records.skip(1)) {
            final DateTime d = DateTime(r.date.year, r.date.month, r.date.day);
            if (!d.isBefore(thirtyDaysBeforeLatest) && d.isBefore(latestDate)) {
              sumPast += r.totalYield;
              countPast++;
            }
          }

          if (countPast >= 3) {
            final double pastAvg = sumPast / countPast;
            if (pastAvg > 0 && latest.totalYield < (pastAvg * 0.70)) {
              final double dropPercent = ((pastAvg - latest.totalYield) / pastAvg) * 100;
              alerts.add(MilkAlert(
                id: 'low_yield_${cattle.id}',
                cattleId: cattle.id,
                title: 'Low Yield Alert',
                message: '#${cattle.id} milk production dropped ${dropPercent.toStringAsFixed(0)}% (${latest.totalYield.toStringAsFixed(1)} L vs ${pastAvg.toStringAsFixed(1)} L avg).',
                severity: AlertSeverity.warning,
                type: 'low_yield',
                date: latest.date,
              ));
            }
          }
        }
      }

      // 3. Dry-Off Reminder
      if (cattle.isPregnant && cattle.expectedCalvingDate != null) {
        final DateTime expectedCalving = cattle.expectedCalvingDate!;
        final int daysToCalving = expectedCalving.difference(today).inDays;

        if (daysToCalving > 0 && daysToCalving <= 60 && cattle.isMilking) {
          alerts.add(MilkAlert(
            id: 'dry_off_${cattle.id}',
            cattleId: cattle.id,
            title: 'Dry-Off Reminder',
            message: '#${cattle.id} is expected to calve in $daysToCalving days. Prepare cow for dry period.',
            severity: AlertSeverity.warning,
            type: 'dry_off_reminder',
            date: expectedCalving,
          ));
        }

        // 4. Calving Reminder & Overdue Alert
        if (daysToCalving < 0) {
          final int daysOverdue = daysToCalving.abs();
          alerts.add(MilkAlert(
            id: 'calving_overdue_${cattle.id}',
            cattleId: cattle.id,
            title: 'Calving Date Overdue',
            message: '#${cattle.id} expected calving date was $daysOverdue day${daysOverdue == 1 ? '' : 's'} ago (${cattle.expectedCalvingDate!.day}/${cattle.expectedCalvingDate!.month}/${cattle.expectedCalvingDate!.year}). Update calving information or pregnancy status.',
            severity: AlertSeverity.danger,
            type: 'calving_overdue',
            date: expectedCalving,
          ));
        } else if (daysToCalving <= 14) {
          alerts.add(MilkAlert(
            id: 'calving_${cattle.id}',
            cattleId: cattle.id,
            title: 'Calving Reminder',
            message: '#${cattle.id} is due for calving in $daysToCalving day${daysToCalving == 1 ? '' : 's'}. Prepare maternity pen.',
            severity: AlertSeverity.danger,
            type: 'calving_reminder',
            date: expectedCalving,
          ));
        }
      }

      // 5. Vaccination Overdue / Due Soon Alerts
      for (final dynamic vax in cattle.vaccinations) {
        final DateTime? nextDue = vax.nextDueDate as DateTime?;
        if (nextDue == null) continue;
        final DateTime dueDate = DateTime(nextDue.year, nextDue.month, nextDue.day);
        final int daysUntilDue = dueDate.difference(today).inDays;
        final String vacName = (vax.vaccineName as String?) ?? 'Vaccine';

        if (daysUntilDue < 0) {
          // Overdue
          final int overdueDays = daysUntilDue.abs();
          alerts.add(MilkAlert(
            id: 'vax_overdue_${cattle.id}_${vacName.replaceAll(' ', '_')}',
            cattleId: cattle.id,
            title: 'Vaccination Overdue',
            message: '#${cattle.id} — $vacName was due $overdueDays day${overdueDays == 1 ? '' : 's'} ago (${dueDate.day}/${dueDate.month}/${dueDate.year}).',
            severity: AlertSeverity.danger,
            type: 'vaccination_overdue',
            date: dueDate,
          ));
        } else if (daysUntilDue <= 30) {
          // Due Soon
          alerts.add(MilkAlert(
            id: 'vax_due_${cattle.id}_${vacName.replaceAll(' ', '_')}',
            cattleId: cattle.id,
            title: 'Vaccination Due Soon',
            message: '#${cattle.id} — $vacName due in $daysUntilDue day${daysUntilDue == 1 ? '' : 's'} (${dueDate.day}/${dueDate.month}/${dueDate.year}).',
            severity: AlertSeverity.warning,
            type: 'vaccination_due',
            date: dueDate,
          ));
        }
      }
    }

    // Sort chronologically (most recent / most urgent first)
    alerts.sort((MilkAlert a, MilkAlert b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return b.date!.compareTo(a.date!);
    });

    return alerts;
  }

  /// Daily Production Trend: Daily totals for the last N days (default 14 days)
  List<MapEntry<DateTime, double>> getDailyProductionTrend({int days = 14, String? breed}) {
    final List<MilkRecord> allRecords = _database.getAllMilkRecords();
    final List<CattleRecord> allCattle = _database.getAllCattle();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final List<MapEntry<DateTime, double>> result = <MapEntry<DateTime, double>>[];

    // Build mapping for fast breed lookup
    final Map<String, String> cattleBreedMap = <String, String>{
      for (final CattleRecord c in allCattle) c.id: c.effectiveBreed
    };

    for (int i = days - 1; i >= 0; i--) {
      final DateTime date = today.subtract(Duration(days: i));
      double sum = 0.0;
      for (final MilkRecord r in allRecords) {
        final DateTime rDate = DateTime(r.date.year, r.date.month, r.date.day);
        if (rDate.isAtSameMomentAs(date)) {
          if (breed == null || cattleBreedMap[r.cattleId] == breed) {
            sum += r.totalYield;
          }
        }
      }
      result.add(MapEntry<DateTime, double>(date, sum));
    }
    return result;
  }

  /// Monthly Production Trend: Monthly totals for the last N months (default 6 months)
  List<MapEntry<String, double>> getMonthlyProductionTrend({int months = 6, String? breed}) {
    final List<MilkRecord> allRecords = _database.getAllMilkRecords();
    final List<CattleRecord> allCattle = _database.getAllCattle();
    final DateTime now = DateTime.now();
    final List<MapEntry<String, double>> result = <MapEntry<String, double>>[];

    final Map<String, String> cattleBreedMap = <String, String>{
      for (final CattleRecord c in allCattle) c.id: c.effectiveBreed
    };

    const List<String> monthNames = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    for (int i = months - 1; i >= 0; i--) {
      final int yearOffset = (now.month - 1 - i) ~/ 12;
      int m = (now.month - i) % 12;
      int y = now.year + yearOffset;
      if (m <= 0) {
        m += 12;
        y -= 1;
      }

      double sum = 0.0;
      for (final MilkRecord r in allRecords) {
        if (r.date.year == y && r.date.month == m) {
          if (breed == null || cattleBreedMap[r.cattleId] == breed) {
            sum += r.totalYield;
          }
        }
      }
      final String label = '${monthNames[m - 1]} ${y.toString().substring(2)}';
      result.add(MapEntry<String, double>(label, sum));
    }
    return result;
  }

  /// Lactation Curve Data: Days in Milk (DIM) vs Yield across herd or individual cow
  List<MapEntry<int, double>> getLactationCurveData({String? cattleId}) {
    final List<CattleRecord> cattles = cattleId != null
        ? (_database.getCattle(cattleId) != null ? <CattleRecord>[_database.getCattle(cattleId)!] : <CattleRecord>[])
        : _database.getAllCattle().where((CattleRecord c) => c.calvingDate != null).toList();

    // Map DIM bucket (0-305 grouped in 15-day intervals) to list of yields
    final Map<int, List<double>> dimBuckets = <int, List<double>>{};
    for (int b = 15; b <= 305; b += 15) {
      dimBuckets[b] = <double>[];
    }

    for (final CattleRecord cattle in cattles) {
      if (cattle.calvingDate == null) continue;
      final DateTime calv = DateTime(cattle.calvingDate!.year, cattle.calvingDate!.month, cattle.calvingDate!.day);
      final List<MilkRecord> records = _database.getMilkRecordsForCattle(cattle.id);

      for (final MilkRecord r in records) {
        final DateTime rDate = DateTime(r.date.year, r.date.month, r.date.day);
        final int dim = rDate.difference(calv).inDays;
        if (dim >= 0 && dim <= 305) {
          // Find matching bucket
          final int bucket = ((dim ~/ 15) + 1) * 15;
          final int safeBucket = bucket > 305 ? 305 : bucket;
          dimBuckets[safeBucket]?.add(r.totalYield);
        }
      }
    }

    final List<MapEntry<int, double>> curve = <MapEntry<int, double>>[];
    for (final int b in dimBuckets.keys.toList()..sort()) {
      final List<double> yields = dimBuckets[b]!;
      if (yields.isNotEmpty) {
        final double avg = yields.reduce((double a, double b) => a + b) / yields.length;
        curve.add(MapEntry<int, double>(b, avg));
      } else {
        curve.add(MapEntry<int, double>(b, 0.0));
      }
    }
    return curve;
  }
}
