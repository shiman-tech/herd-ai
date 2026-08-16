import 'package:flutter_test/flutter_test.dart';
import 'package:herd_ai/models/cattle_filter.dart';
import 'package:herd_ai/models/cattle_record.dart';

void main() {
  group('CattleRecord Fallbacks and Calculations', () {
    test('calculates age in months and display correctly', () {
      final DateTime now = DateTime.now();
      final DateTime dob = DateTime(now.year - 2, now.month - 3, now.day);
      final CattleRecord record = CattleRecord(
        id: 'C-01',
        registrationDate: now,
        dateOfBirth: dob,
      );

      expect(record.ageInMonths, 27);
      expect(record.ageDisplay, '2 yrs 3 mos');
    });

    test('infers life stage when not explicitly set', () {
      final DateTime now = DateTime.now();
      // Calf (< 12 months)
      final CattleRecord calf = CattleRecord(
        id: 'C-01',
        registrationDate: now,
        sex: 'Female',
        dateOfBirth: DateTime(now.year, now.month - 6, now.day),
      );
      expect(calf.effectiveLifeStage, 'Calf');

      // Heifer (Female, 12 - 24 months)
      final CattleRecord heifer = CattleRecord(
        id: 'C-02',
        registrationDate: now,
        sex: 'Female',
        dateOfBirth: DateTime(now.year - 1, now.month - 3, now.day),
      );
      expect(heifer.effectiveLifeStage, 'Heifer');

      // Cow (Female, >= 24 months)
      final CattleRecord cow = CattleRecord(
        id: 'C-03',
        registrationDate: now,
        sex: 'Female',
        dateOfBirth: DateTime(now.year - 3, now.month, now.day),
      );
      expect(cow.effectiveLifeStage, 'Cow');

      // Bull (Male)
      final CattleRecord bull = CattleRecord(
        id: 'C-04',
        registrationDate: now,
        sex: 'Male',
        dateOfBirth: DateTime(now.year - 3, now.month, now.day),
      );
      expect(bull.effectiveLifeStage, 'Bull');
    });

    test('calculates effective health status from health records', () {
      final DateTime now = DateTime.now();
      // No records -> Healthy
      final CattleRecord healthy = CattleRecord(
        id: 'C-01',
        registrationDate: now,
      );
      expect(healthy.effectiveHealthStatus, 'Healthy');

      // Ongoing disease -> Diseased
      final CattleRecord diseased = CattleRecord(
        id: 'C-02',
        registrationDate: now,
        healthRecords: <HealthRecord>[
          HealthRecord(
            diseaseName: 'Mastitis',
            date: now,
            status: 'Ongoing',
          ),
        ],
      );
      expect(diseased.effectiveHealthStatus, 'Diseased');

      // All recovered -> Recovered
      final CattleRecord recovered = CattleRecord(
        id: 'C-03',
        registrationDate: now,
        healthRecords: <HealthRecord>[
          HealthRecord(
            diseaseName: 'Foot Rot',
            date: now.subtract(const Duration(days: 30)),
            status: 'Recovered',
          ),
        ],
      );
      expect(recovered.effectiveHealthStatus, 'Recovered');
    });

    test('calculates vaccination status correctly', () {
      final DateTime now = DateTime.now();
      // No records
      final CattleRecord noVax = CattleRecord(id: 'C-01', registrationDate: now);
      expect(noVax.calculatedVaccinationStatus, 'No Record');

      // Overdue
      final CattleRecord overdue = CattleRecord(
        id: 'C-02',
        registrationDate: now,
        vaccinations: <VaccinationRecord>[
          VaccinationRecord(
            vaccineName: 'FMD',
            dateGiven: now.subtract(const Duration(days: 180)),
            nextDueDate: now.subtract(const Duration(days: 10)),
          ),
        ],
      );
      expect(overdue.calculatedVaccinationStatus, 'Overdue');

      // Due soon (within 30 days)
      final CattleRecord dueSoon = CattleRecord(
        id: 'C-03',
        registrationDate: now,
        vaccinations: <VaccinationRecord>[
          VaccinationRecord(
            vaccineName: 'Brucellosis',
            dateGiven: now.subtract(const Duration(days: 150)),
            nextDueDate: now.add(const Duration(days: 15)),
          ),
        ],
      );
      expect(dueSoon.calculatedVaccinationStatus, 'Due Soon');

      // Up to Date
      final CattleRecord upToDate = CattleRecord(
        id: 'C-04',
        registrationDate: now,
        vaccinations: <VaccinationRecord>[
          VaccinationRecord(
            vaccineName: 'Anthrax',
            dateGiven: now.subtract(const Duration(days: 30)),
            nextDueDate: now.add(const Duration(days: 100)),
          ),
        ],
      );
      expect(upToDate.calculatedVaccinationStatus, 'Up to Date');
    });
  });

  group('CattleFilterCriteria Multi-Filtering', () {
    late List<CattleRecord> herd;
    final DateTime now = DateTime.now();

    setUp(() {
      herd = <CattleRecord>[
        // Cattle 1: Female, Diseased, Pregnant, Gir
        CattleRecord(
          id: 'COW-101',
          registrationDate: now.subtract(const Duration(days: 5)),
          sex: 'Female',
          lifeStage: 'Cow',
          healthStatus: 'Diseased',
          reproductiveStatus: 'Pregnant',
          confirmedBreed: 'Gir',
          dateOfBirth: DateTime(now.year - 4, now.month, now.day),
        ),
        // Cattle 2: Male, Healthy, Bull, Sahiwal
        CattleRecord(
          id: 'BULL-202',
          registrationDate: now.subtract(const Duration(days: 10)),
          sex: 'Male',
          lifeStage: 'Bull',
          healthStatus: 'Healthy',
          reproductiveStatus: 'Not Pregnant',
          confirmedBreed: 'Sahiwal',
          dateOfBirth: DateTime(now.year - 5, now.month, now.day),
        ),
        // Cattle 3: Female, Healthy, Calf, Unknown Breed
        CattleRecord(
          id: 'CALF-303',
          registrationDate: now.subtract(const Duration(days: 1)),
          sex: 'Female',
          lifeStage: 'Calf',
          healthStatus: 'Healthy',
          reproductiveStatus: 'Unknown',
          dateOfBirth: DateTime(now.year, now.month - 4, now.day),
        ),
      ];
    });

    test('combines Female + Diseased + Pregnant', () {
      final CattleFilterCriteria filter = CattleFilterCriteria();
      filter.selectedSexes.add('Female');
      filter.selectedHealthStatuses.add('Diseased');
      filter.selectedReproductiveStatuses.add('Pregnant');

      final List<CattleRecord> results = filter.filterAndSort(herd, '');
      expect(results.length, 1);
      expect(results.first.id, 'COW-101');
    });

    test('combines Male + Bull + Healthy', () {
      final CattleFilterCriteria filter = CattleFilterCriteria();
      filter.selectedSexes.add('Male');
      filter.selectedLifeStages.add('Bull');
      filter.selectedHealthStatuses.add('Healthy');

      final List<CattleRecord> results = filter.filterAndSort(herd, '');
      expect(results.length, 1);
      expect(results.first.id, 'BULL-202');
    });

    test('filters by Breed including Unknown', () {
      final CattleFilterCriteria filter = CattleFilterCriteria();
      filter.selectedBreeds.add('Unknown');

      final List<CattleRecord> results = filter.filterAndSort(herd, '');
      expect(results.length, 1);
      expect(results.first.id, 'CALF-303');
    });

    test('combines Text Search with Filter', () {
      final CattleFilterCriteria filter = CattleFilterCriteria();
      filter.selectedHealthStatuses.add('Healthy');

      // Search '202'
      final List<CattleRecord> results = filter.filterAndSort(herd, '202');
      expect(results.length, 1);
      expect(results.first.id, 'BULL-202');

      // Search '999' (no match)
      final List<CattleRecord> emptyResults = filter.filterAndSort(herd, '999');
      expect(emptyResults.isEmpty, true);
    });

    test('sorts by Age ascending and descending', () {
      final CattleFilterCriteria filter = CattleFilterCriteria();

      // Age Youngest first
      filter.sortOption = CattleSortOption.ageAsc;
      final List<CattleRecord> ascResults = filter.filterAndSort(herd, '');
      expect(ascResults.map((CattleRecord c) => c.id).toList(), <String>[
        'CALF-303',
        'COW-101',
        'BULL-202',
      ]);

      // Age Oldest first
      filter.sortOption = CattleSortOption.ageDesc;
      final List<CattleRecord> descResults = filter.filterAndSort(herd, '');
      expect(descResults.map((CattleRecord c) => c.id).toList(), <String>[
        'BULL-202',
        'COW-101',
        'CALF-303',
      ]);
    });

    test('sorts by ID ascending and descending', () {
      final CattleFilterCriteria filter = CattleFilterCriteria();

      filter.sortOption = CattleSortOption.nameAsc;
      final List<CattleRecord> ascResults = filter.filterAndSort(herd, '');
      expect(ascResults.first.id, 'BULL-202');
      expect(ascResults.last.id, 'COW-101');

      filter.sortOption = CattleSortOption.nameDesc;
      final List<CattleRecord> descResults = filter.filterAndSort(herd, '');
      expect(descResults.first.id, 'COW-101');
      expect(descResults.last.id, 'BULL-202');
    });
  });
}
