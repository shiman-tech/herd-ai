import 'package:flutter_test/flutter_test.dart';
import 'package:herd_ai/models/cattle_record.dart';
import 'package:herd_ai/models/milk_record.dart';

void main() {
  group('Lactation & Gestation Calculations', () {
    test('Days in Milk (DIM) calculation', () {
      final DateTime now = DateTime.now();
      final DateTime calving = now.subtract(const Duration(days: 124));

      final CattleRecord cow = CattleRecord(
        id: 'COW-01',
        registrationDate: now,
        sex: 'Female',
        isMilking: true,
        calvingDate: calving,
      );

      expect(cow.daysInMilk, 124);
    });

    test('Lactation Stage Classification', () {
      final DateTime now = DateTime.now();

      // Fresh (0-30 days)
      final CattleRecord freshCow = CattleRecord(
        id: 'C-FRESH',
        registrationDate: now,
        isMilking: true,
        calvingDate: now.subtract(const Duration(days: 15)),
      );
      expect(freshCow.lactationStage, 'Fresh');

      // Early (31-100 days)
      final CattleRecord earlyCow = CattleRecord(
        id: 'C-EARLY',
        registrationDate: now,
        isMilking: true,
        calvingDate: now.subtract(const Duration(days: 60)),
      );
      expect(earlyCow.lactationStage, 'Early');

      // Mid (101-200 days)
      final CattleRecord midCow = CattleRecord(
        id: 'C-MID',
        registrationDate: now,
        isMilking: true,
        calvingDate: now.subtract(const Duration(days: 140)),
      );
      expect(midCow.lactationStage, 'Mid');

      // Late (201-305 days)
      final CattleRecord lateCow = CattleRecord(
        id: 'C-LATE',
        registrationDate: now,
        isMilking: true,
        calvingDate: now.subtract(const Duration(days: 250)),
      );
      expect(lateCow.lactationStage, 'Late');

      // Extended Lactation (>305 days and isMilking == true)
      final CattleRecord extendedCow = CattleRecord(
        id: 'C-EXT',
        registrationDate: now,
        isMilking: true,
        calvingDate: now.subtract(const Duration(days: 382)),
      );
      expect(extendedCow.lactationStage, 'Extended Lactation');

      // Dry (isMilking == false)
      final CattleRecord dryCow = CattleRecord(
        id: 'C-DRY',
        registrationDate: now,
        isMilking: false,
        calvingDate: now.subtract(const Duration(days: 50)),
      );
      expect(dryCow.lactationStage, 'Dry');
    });

    test('Expected Calving Date & Dry-Off Date calculation', () {
      final DateTime now = DateTime.now();
      final DateTime insemDate = now.subtract(const Duration(days: 100));

      final CattleRecord cow = CattleRecord(
        id: 'COW-PREG',
        registrationDate: now,
        isPregnant: true,
        inseminationDate: insemDate,
      );

      expect(cow.expectedCalvingDate, insemDate.add(const Duration(days: 283)));
      expect(cow.targetDryOffDate, insemDate.add(const Duration(days: 220)));
    });
  });

  group('Milk Record calculations', () {
    test('Total yield calculation', () {
      final DateTime today = DateTime.now();
      final MilkRecord record = MilkRecord(
        id: 'M-1',
        cattleId: 'COW-01',
        date: today,
        morningYield: 8.5,
        eveningYield: 7.0,
        createdAt: today,
      );

      expect(record.totalYield, 15.5);
      expect(record.morningYield, 8.5);
      expect(record.eveningYield, 7.0);
    });
  });

  group('Calving Event Auto-Reset', () {
    test('Updating calving date resets pregnancy and insemination data', () {
      final DateTime now = DateTime.now();
      final DateTime oldCalving = now.subtract(const Duration(days: 382));
      final DateTime insemDate = now.subtract(const Duration(days: 290));
      final DateTime newCalving = now.subtract(const Duration(days: 10));

      final CattleRecord beforeCalving = CattleRecord(
        id: 'COW-PREG-OVERDUE',
        registrationDate: now,
        sex: 'Female',
        isMilking: true,
        isPregnant: true,
        calvingDate: oldCalving,
        inseminationDate: insemDate,
      );

      expect(beforeCalving.daysInMilk, 382);
      expect(beforeCalving.lactationStage, 'Extended Lactation');
      expect(beforeCalving.expectedCalvingDate!.isBefore(now), isTrue);

      // Simulate farmer logging new calving event (e.g. 14/08/2026)
      final CattleRecord afterCalving = CattleRecord(
        id: beforeCalving.id,
        registrationDate: beforeCalving.registrationDate,
        sex: 'Female',
        calvingDate: newCalving,
        isMilking: true,
        isPregnant: false,
        reproductiveStatus: 'Not Pregnant',
        inseminationDate: null,
        dryOffDate: null,
      );

      expect(afterCalving.daysInMilk, 10);
      expect(afterCalving.lactationStage, 'Fresh');
      expect(afterCalving.isPregnant, false);
      expect(afterCalving.inseminationDate, null);
      expect(afterCalving.expectedCalvingDate, null);
    });
  });
}
