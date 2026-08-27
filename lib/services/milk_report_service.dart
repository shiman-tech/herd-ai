import '../models/cattle_record.dart';
import '../models/milk_record.dart';
import 'embedding_database.dart';

class DailyReportItem {
  const DailyReportItem({
    required this.cattleId,
    required this.morningYield,
    required this.eveningYield,
    required this.totalYield,
    this.notes,
  });

  final String cattleId;
  final double morningYield;
  final double eveningYield;
  final double totalYield;
  final String? notes;
}

class WeeklyReportSummary {
  const WeeklyReportSummary({
    required this.startDate,
    required this.endDate,
    required this.totalYield,
    required this.averageDailyYield,
    required this.bestProducingCow,
    required this.bestProducingCowYield,
    required this.lowestProducingCow,
    required this.lowestProducingCowYield,
    required this.activeMilkingCowsCount,
  });

  final DateTime startDate;
  final DateTime endDate;
  final double totalYield;
  final double averageDailyYield;
  final String? bestProducingCow;
  final double bestProducingCowYield;
  final String? lowestProducingCow;
  final double lowestProducingCowYield;
  final int activeMilkingCowsCount;
}

class MonthlyReportSummary {
  const MonthlyReportSummary({
    required this.year,
    required this.month,
    required this.totalYield,
    required this.averageDailyYield,
    required this.bestProducingCow,
    required this.bestProducingCowYield,
    required this.lowestProducingCow,
    required this.lowestProducingCowYield,
    required this.activeMilkingCowsCount,
  });

  final int year;
  final int month;
  final double totalYield;
  final double averageDailyYield;
  final String? bestProducingCow;
  final double bestProducingCowYield;
  final String? lowestProducingCow;
  final double lowestProducingCowYield;
  final int activeMilkingCowsCount;
}

class MilkReportService {
  MilkReportService({EmbeddingDatabase? database})
      : _database = database ?? EmbeddingDatabase.instance;

  final EmbeddingDatabase _database;

  // Helper map for cattle breed lookup
  Map<String, String> _getCattleBreedMap() {
    return <String, String>{
      for (final CattleRecord c in _database.getAllCattle()) c.id: c.effectiveBreed
    };
  }

  /// Generate Daily Report items for a given date
  List<DailyReportItem> getDailyReport(DateTime date, {String? breed}) {
    final List<MilkRecord> allRecords = _database.getAllMilkRecords();
    final Map<String, String> cattleBreedMap = _getCattleBreedMap();
    final DateTime target = DateTime(date.year, date.month, date.day);

    final List<MilkRecord> matched = allRecords.where((MilkRecord r) {
      final DateTime rDate = DateTime(r.date.year, r.date.month, r.date.day);
      final bool dateMatch = rDate.isAtSameMomentAs(target);
      final bool breedMatch = breed == null || cattleBreedMap[r.cattleId] == breed;
      return dateMatch && breedMatch;
    }).toList()
      ..sort((MilkRecord a, MilkRecord b) => b.totalYield.compareTo(a.totalYield));

    return matched.map((MilkRecord r) {
      return DailyReportItem(
        cattleId: r.cattleId,
        morningYield: r.morningYield,
        eveningYield: r.eveningYield,
        totalYield: r.totalYield,
        notes: r.notes,
      );
    }).toList();
  }

  /// Generate CSV string for Daily Report
  String exportDailyReportCsv(DateTime date, {String? breed}) {
    final List<DailyReportItem> items = getDailyReport(date, breed: breed);
    final String dateStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final StringBuffer buffer = StringBuffer();
    final String breedHeader = breed != null ? ' - Breed: $breed' : ' - All Breeds';
    buffer.writeln('Herd AI - Daily Milk Yield Report ($dateStr)$breedHeader');
    buffer.writeln('Cattle ID,Morning (L),Evening (L),Total Yield (L),Notes');

    double grandTotal = 0.0;
    for (final DailyReportItem item in items) {
      grandTotal += item.totalYield;
      final String noteSafe = item.notes != null ? '"${item.notes!.replaceAll('"', '""')}"' : '';
      buffer.writeln('${item.cattleId},${item.morningYield.toStringAsFixed(1)},${item.eveningYield.toStringAsFixed(1)},${item.totalYield.toStringAsFixed(1)},$noteSafe');
    }
    buffer.writeln('Total,,,$grandTotal,');
    return buffer.toString();
  }

  /// Generate Weekly Summary
  WeeklyReportSummary getWeeklyReportSummary(DateTime startDate, {String? breed}) {
    final List<MilkRecord> allRecords = _database.getAllMilkRecords();
    final Map<String, String> cattleBreedMap = _getCattleBreedMap();
    
    final DateTime start = DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime end = start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    final Map<String, double> cowTotals = <String, double>{};
    double totalWeekYield = 0.0;

    for (final MilkRecord r in allRecords) {
      final DateTime rDate = DateTime(r.date.year, r.date.month, r.date.day);
      if (!rDate.isBefore(start) && !rDate.isAfter(end)) {
        if (breed == null || cattleBreedMap[r.cattleId] == breed) {
          totalWeekYield += r.totalYield;
          cowTotals[r.cattleId] = (cowTotals[r.cattleId] ?? 0.0) + r.totalYield;
        }
      }
    }

    String? bestCow;
    double bestYield = -1;
    String? lowCow;
    double lowYield = double.infinity;

    for (final MapEntry<String, double> entry in cowTotals.entries) {
      if (entry.value > bestYield) {
        bestYield = entry.value;
        bestCow = entry.key;
      }
      if (entry.value < lowYield) {
        lowYield = entry.value;
        lowCow = entry.key;
      }
    }

    final double avgDaily = totalWeekYield / 7.0;

    return WeeklyReportSummary(
      startDate: start,
      endDate: end,
      totalYield: totalWeekYield,
      averageDailyYield: avgDaily,
      bestProducingCow: bestCow,
      bestProducingCowYield: bestYield >= 0 ? bestYield : 0.0,
      lowestProducingCow: lowCow,
      lowestProducingCowYield: (lowYield != double.infinity) ? lowYield : 0.0,
      activeMilkingCowsCount: cowTotals.length,
    );
  }

  /// Generate CSV string for Weekly Report
  String exportWeeklyReportCsv(DateTime startDate, {String? breed}) {
    final List<MilkRecord> allRecords = _database.getAllMilkRecords();
    final Map<String, String> cattleBreedMap = _getCattleBreedMap();

    final DateTime start = DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime end = start.add(const Duration(days: 6));

    final Map<String, double> cowTotals = <String, double>{};
    final Map<String, int> cowDaysMilked = <String, int>{};

    for (final MilkRecord r in allRecords) {
      final DateTime rDate = DateTime(r.date.year, r.date.month, r.date.day);
      if (!rDate.isBefore(start) && !rDate.isAfter(end)) {
        if (breed == null || cattleBreedMap[r.cattleId] == breed) {
          cowTotals[r.cattleId] = (cowTotals[r.cattleId] ?? 0.0) + r.totalYield;
          cowDaysMilked[r.cattleId] = (cowDaysMilked[r.cattleId] ?? 0) + 1;
        }
      }
    }

    final WeeklyReportSummary summary = getWeeklyReportSummary(startDate, breed: breed);
    final String startStr = '${start.day}/${start.month}/${start.year}';
    final String endStr = '${end.day}/${end.month}/${end.year}';
    final String breedHeader = breed != null ? ' - Breed: $breed' : ' - All Breeds';
    final String title = 'Herd AI - Weekly Milk Report ($startStr to $endStr)$breedHeader';

    final StringBuffer buffer = StringBuffer();
    buffer.writeln(title);
    buffer.writeln('Total Weekly Herd Yield,${summary.totalYield.toStringAsFixed(1)} L');
    buffer.writeln('Daily Average,${summary.averageDailyYield.toStringAsFixed(1)} L/day');
    buffer.writeln('Best Cow,${summary.bestProducingCow ?? 'N/A'} (${summary.bestProducingCowYield.toStringAsFixed(1)} L)');
    buffer.writeln('Lowest Cow,${summary.lowestProducingCow ?? 'N/A'} (${summary.lowestProducingCowYield.toStringAsFixed(1)} L)');
    buffer.writeln('');
    buffer.writeln('Cattle ID,Days Recorded,Total Week Yield (L),Avg Yield/Day (L)');

    for (final String cId in cowTotals.keys.toList()..sort()) {
      final double tot = cowTotals[cId]!;
      final int days = cowDaysMilked[cId]!;
      final double avg = days > 0 ? (tot / days) : 0.0;
      buffer.writeln('$cId,$days,${tot.toStringAsFixed(1)},${avg.toStringAsFixed(1)}');
    }

    return buffer.toString();
  }

  /// Generate Monthly Summary
  MonthlyReportSummary getMonthlyReportSummary(int year, int month, {String? breed}) {
    final List<MilkRecord> allRecords = _database.getAllMilkRecords();
    final Map<String, String> cattleBreedMap = _getCattleBreedMap();
    final Map<String, double> cowTotals = <String, double>{};
    double totalMonthYield = 0.0;

    for (final MilkRecord r in allRecords) {
      if (r.date.year == year && r.date.month == month) {
        if (breed == null || cattleBreedMap[r.cattleId] == breed) {
          totalMonthYield += r.totalYield;
          cowTotals[r.cattleId] = (cowTotals[r.cattleId] ?? 0.0) + r.totalYield;
        }
      }
    }

    String? bestCow;
    double bestYield = -1;
    String? lowCow;
    double lowYield = double.infinity;

    for (final MapEntry<String, double> entry in cowTotals.entries) {
      if (entry.value > bestYield) {
        bestYield = entry.value;
        bestCow = entry.key;
      }
      if (entry.value < lowYield) {
        lowYield = entry.value;
        lowCow = entry.key;
      }
    }

    final int daysInMonth = DateTime(year, month + 1, 0).day;
    final double avgDaily = totalMonthYield > 0 ? (totalMonthYield / daysInMonth) : 0.0;

    return MonthlyReportSummary(
      year: year,
      month: month,
      totalYield: totalMonthYield,
      averageDailyYield: avgDaily,
      bestProducingCow: bestCow,
      bestProducingCowYield: bestYield >= 0 ? bestYield : 0.0,
      lowestProducingCow: lowCow,
      lowestProducingCowYield: (lowYield != double.infinity) ? lowYield : 0.0,
      activeMilkingCowsCount: cowTotals.length,
    );
  }

  /// Generate CSV string for Monthly Report
  String exportMonthlyReportCsv(int year, int month, {String? breed}) {
    final List<MilkRecord> allRecords = _database.getAllMilkRecords();
    final Map<String, String> cattleBreedMap = _getCattleBreedMap();
    final Map<String, double> cowTotals = <String, double>{};
    final Map<String, int> cowDaysMilked = <String, int>{};

    for (final MilkRecord r in allRecords) {
      if (r.date.year == year && r.date.month == month) {
        if (breed == null || cattleBreedMap[r.cattleId] == breed) {
          cowTotals[r.cattleId] = (cowTotals[r.cattleId] ?? 0.0) + r.totalYield;
          cowDaysMilked[r.cattleId] = (cowDaysMilked[r.cattleId] ?? 0) + 1;
        }
      }
    }

    final MonthlyReportSummary summary = getMonthlyReportSummary(year, month, breed: breed);
    const List<String> monthNames = <String>[
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final String breedHeader = breed != null ? ' - Breed: $breed' : ' - All Breeds';
    final String title = 'Herd AI - Monthly Milk Report (${monthNames[month - 1]} $year)$breedHeader';

    final StringBuffer buffer = StringBuffer();
    buffer.writeln(title);
    buffer.writeln('Total Herd Yield,${summary.totalYield.toStringAsFixed(1)} L');
    buffer.writeln('Daily Average,${summary.averageDailyYield.toStringAsFixed(1)} L/day');
    buffer.writeln('Best Cow,${summary.bestProducingCow ?? 'N/A'} (${summary.bestProducingCowYield.toStringAsFixed(1)} L)');
    buffer.writeln('Lowest Cow,${summary.lowestProducingCow ?? 'N/A'} (${summary.lowestProducingCowYield.toStringAsFixed(1)} L)');
    buffer.writeln('');
    buffer.writeln('Cattle ID,Days Recorded,Total Month Yield (L),Avg Yield/Day (L)');

    for (final String cId in cowTotals.keys.toList()..sort()) {
      final double tot = cowTotals[cId]!;
      final int days = cowDaysMilked[cId]!;
      final double avg = days > 0 ? (tot / days) : 0.0;
      buffer.writeln('$cId,$days,${tot.toStringAsFixed(1)},${avg.toStringAsFixed(1)}');
    }

    return buffer.toString();
  }
}
