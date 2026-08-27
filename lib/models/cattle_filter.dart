import 'cattle_record.dart';

enum CattleSortOption {
  recentlyAdded,
  oldestAdded,
  nameAsc,
  nameDesc,
  ageAsc,
  ageDesc;

  String get label {
    switch (this) {
      case CattleSortOption.recentlyAdded:
        return 'Recently Added';
      case CattleSortOption.oldestAdded:
        return 'Oldest Added';
      case CattleSortOption.nameAsc:
        return 'ID (A → Z)';
      case CattleSortOption.nameDesc:
        return 'ID (Z → A)';
      case CattleSortOption.ageAsc:
        return 'Age (Youngest)';
      case CattleSortOption.ageDesc:
        return 'Age (Oldest)';
    }
  }
}

class ActiveFilterItem {
  const ActiveFilterItem({
    required this.category,
    required this.value,
    required this.label,
  });

  final String category;
  final String value;
  final String label;
}

class CattleFilterCriteria {
  CattleFilterCriteria({
    Set<String>? selectedSexes,
    Set<String>? selectedLifeStages,
    Set<String>? selectedHealthStatuses,
    Set<String>? selectedReproductiveStatuses,
    Set<String>? selectedVaccinationStatuses,
    Set<String>? selectedBreeds,
    Set<String>? selectedMilkStatuses,
    this.sortOption = CattleSortOption.recentlyAdded,
  }) : selectedSexes = selectedSexes ?? <String>{},
       selectedLifeStages = selectedLifeStages ?? <String>{},
       selectedHealthStatuses = selectedHealthStatuses ?? <String>{},
       selectedReproductiveStatuses = selectedReproductiveStatuses ?? <String>{},
       selectedVaccinationStatuses = selectedVaccinationStatuses ?? <String>{},
       selectedBreeds = selectedBreeds ?? <String>{},
       selectedMilkStatuses = selectedMilkStatuses ?? <String>{};

  final Set<String> selectedSexes;
  final Set<String> selectedLifeStages;
  final Set<String> selectedHealthStatuses;
  final Set<String> selectedReproductiveStatuses;
  final Set<String> selectedVaccinationStatuses;
  final Set<String> selectedBreeds;
  final Set<String> selectedMilkStatuses;
  CattleSortOption sortOption;

  int get activeFilterCount =>
      selectedSexes.length +
      selectedLifeStages.length +
      selectedHealthStatuses.length +
      selectedReproductiveStatuses.length +
      selectedVaccinationStatuses.length +
      selectedBreeds.length +
      selectedMilkStatuses.length;

  bool get hasActiveFilters => activeFilterCount > 0;

  void reset() {
    selectedSexes.clear();
    selectedLifeStages.clear();
    selectedHealthStatuses.clear();
    selectedReproductiveStatuses.clear();
    selectedVaccinationStatuses.clear();
    selectedBreeds.clear();
    selectedMilkStatuses.clear();
    sortOption = CattleSortOption.recentlyAdded;
  }

  CattleFilterCriteria clone() {
    return CattleFilterCriteria(
      selectedSexes: Set<String>.from(selectedSexes),
      selectedLifeStages: Set<String>.from(selectedLifeStages),
      selectedHealthStatuses: Set<String>.from(selectedHealthStatuses),
      selectedReproductiveStatuses: Set<String>.from(selectedReproductiveStatuses),
      selectedVaccinationStatuses: Set<String>.from(selectedVaccinationStatuses),
      selectedBreeds: Set<String>.from(selectedBreeds),
      selectedMilkStatuses: Set<String>.from(selectedMilkStatuses),
      sortOption: sortOption,
    );
  }

  List<ActiveFilterItem> get activeFilterItems {
    final List<ActiveFilterItem> items = <ActiveFilterItem>[];
    for (final String sex in selectedSexes) {
      items.add(ActiveFilterItem(category: 'Sex', value: sex, label: sex));
    }
    for (final String stage in selectedLifeStages) {
      items.add(ActiveFilterItem(category: 'Life Stage', value: stage, label: stage));
    }
    for (final String health in selectedHealthStatuses) {
      items.add(ActiveFilterItem(category: 'Health', value: health, label: health));
    }
    for (final String repro in selectedReproductiveStatuses) {
      items.add(ActiveFilterItem(category: 'Reproductive', value: repro, label: repro));
    }
    for (final String vax in selectedVaccinationStatuses) {
      items.add(ActiveFilterItem(category: 'Vaccination', value: vax, label: vax));
    }
    for (final String breed in selectedBreeds) {
      items.add(ActiveFilterItem(category: 'Breed', value: breed, label: breed));
    }
    for (final String milk in selectedMilkStatuses) {
      items.add(ActiveFilterItem(category: 'Milk & Lactation', value: milk, label: milk));
    }
    return items;
  }

  void removeFilter(ActiveFilterItem item) {
    switch (item.category) {
      case 'Sex':
        selectedSexes.remove(item.value);
        break;
      case 'Life Stage':
        selectedLifeStages.remove(item.value);
        break;
      case 'Health':
        selectedHealthStatuses.remove(item.value);
        break;
      case 'Reproductive':
        selectedReproductiveStatuses.remove(item.value);
        break;
      case 'Vaccination':
        selectedVaccinationStatuses.remove(item.value);
        break;
      case 'Breed':
        selectedBreeds.remove(item.value);
        break;
      case 'Milk & Lactation':
        selectedMilkStatuses.remove(item.value);
        break;
    }
  }

  bool _matchesSet(Set<String> filterSet, String actualValue) {
    if (filterSet.isEmpty) {
      return true;
    }
    return filterSet.any(
      (String item) => item.trim().toLowerCase() == actualValue.trim().toLowerCase(),
    );
  }

  bool matches(CattleRecord record, String searchQuery, {Map<String, double>? cowAvgYields}) {
    // 1. Text search
    final String query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      final bool idMatch = record.id.toLowerCase().contains(query);
      final bool breedMatch = record.effectiveBreed.toLowerCase().contains(query);
      final bool noteMatch = record.notes.any((String n) => n.toLowerCase().contains(query));
      if (!idMatch && !breedMatch && !noteMatch) {
        return false;
      }
    }

    // 2. Sex filter
    if (!_matchesSet(selectedSexes, record.effectiveSex)) {
      return false;
    }

    // 3. Life stage filter
    if (!_matchesSet(selectedLifeStages, record.effectiveLifeStage)) {
      return false;
    }

    // 4. Health status filter
    if (!_matchesSet(selectedHealthStatuses, record.effectiveHealthStatus)) {
      return false;
    }

    // 5. Reproductive status filter
    if (!_matchesSet(selectedReproductiveStatuses, record.effectiveReproductiveStatus)) {
      return false;
    }

    // 6. Vaccination status filter
    if (!_matchesSet(selectedVaccinationStatuses, record.calculatedVaccinationStatus)) {
      return false;
    }

    // 7. Breed filter
    if (!_matchesSet(selectedBreeds, record.effectiveBreed)) {
      return false;
    }

    // 8. Milk & Lactation filter
    if (selectedMilkStatuses.isNotEmpty) {
      bool matchedAnyMilkStatus = false;
      final double cowYield = (cowAvgYields != null && cowAvgYields.containsKey(record.id))
          ? cowAvgYields[record.id]!
          : (record.expectedDailyYield ?? 0.0);

      for (final String status in selectedMilkStatuses) {
        if (status == 'Milking Cows' && record.isMilking) {
          matchedAnyMilkStatus = true;
          break;
        }
        if (status == 'Dry Cows' && !record.isMilking) {
          matchedAnyMilkStatus = true;
          break;
        }
        if (status == 'High Producers (>15 L/day)' && cowYield > 15.0) {
          matchedAnyMilkStatus = true;
          break;
        }
        if (status == 'Medium Producers (8–15 L/day)' && cowYield >= 8.0 && cowYield <= 15.0) {
          matchedAnyMilkStatus = true;
          break;
        }
        if (status == 'Low Producers (<8 L/day)' && cowYield > 0 && cowYield < 8.0) {
          matchedAnyMilkStatus = true;
          break;
        }
        if (status == 'Recently Calved') {
          final int? dim = record.daysInMilk;
          if (dim != null && dim <= 30) {
            matchedAnyMilkStatus = true;
            break;
          }
        }
      }
      if (!matchedAnyMilkStatus) {
        return false;
      }
    }

    return true;
  }

  List<CattleRecord> filterAndSort(List<CattleRecord> cattleList, String searchQuery, {Map<String, double>? cowAvgYields}) {
    final List<CattleRecord> filtered = cattleList
        .where((CattleRecord cattle) => matches(cattle, searchQuery, cowAvgYields: cowAvgYields))
        .toList();

    filtered.sort((CattleRecord a, CattleRecord b) {
      switch (sortOption) {
        case CattleSortOption.nameAsc:
          return a.id.toLowerCase().compareTo(b.id.toLowerCase());
        case CattleSortOption.nameDesc:
          return b.id.toLowerCase().compareTo(a.id.toLowerCase());
        case CattleSortOption.recentlyAdded:
          return b.registrationDate.compareTo(a.registrationDate);
        case CattleSortOption.oldestAdded:
          return a.registrationDate.compareTo(b.registrationDate);
        case CattleSortOption.ageAsc:
          final int aMonths = a.ageInMonths ?? 99999;
          final int bMonths = b.ageInMonths ?? 99999;
          if (aMonths != bMonths) {
            return aMonths.compareTo(bMonths);
          }
          return a.id.compareTo(b.id);
        case CattleSortOption.ageDesc:
          final int aMonths = a.ageInMonths ?? -1;
          final int bMonths = b.ageInMonths ?? -1;
          if (aMonths != bMonths) {
            return bMonths.compareTo(aMonths);
          }
          return a.id.compareTo(b.id);
      }
    });

    return filtered;
  }
}
