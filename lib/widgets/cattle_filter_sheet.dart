import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cattle_filter.dart';
import '../models/cattle_record.dart';
import '../utils/localized_labels.dart';

class CattleFilterSheet extends StatefulWidget {
  const CattleFilterSheet({
    super.key,
    required this.initialFilter,
    required this.allCattle,
    required this.searchQuery,
  });

  final CattleFilterCriteria initialFilter;
  final List<CattleRecord> allCattle;
  final String searchQuery;

  @override
  State<CattleFilterSheet> createState() => _CattleFilterSheetState();
}

class _CattleFilterSheetState extends State<CattleFilterSheet> {
  late CattleFilterCriteria _filter;
  late List<String> _availableBreeds;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter.clone();

    // Extract all unique breeds from the herd
    final Set<String> breedSet = <String>{};
    for (final CattleRecord c in widget.allCattle) {
      breedSet.add(c.effectiveBreed);
    }
    _availableBreeds = breedSet.toList()..sort();
    if (!_availableBreeds.contains('Unknown')) {
      _availableBreeds.add('Unknown');
    }
  }

  int get _matchingCount {
    return widget.allCattle
        .where((CattleRecord c) => _filter.matches(c, widget.searchQuery))
        .length;
  }

  Widget _buildSectionHeader(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 18, color: const Color(0xFF2D6A4F)),
            const SizedBox(width: 6),
          ],
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    Color? activeColor,
    Color? activeTextColor,
  }) {
    final Color chipColor = activeColor ?? const Color(0xFF2D6A4F);
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? (activeTextColor ?? Colors.white) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip<T>({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    IconData? icon,
  }) {
    const Color chipColor = Color(0xFF2D6A4F);
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSetItem(Set<String> set, String item) {
    setState(() {
      if (set.contains(item)) {
        set.remove(item);
      } else {
        set.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final int matching = _matchingCount;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Icons.tune, color: Color(0xFF2D6A4F)),
                const SizedBox(width: 8),
                Text(
                  l10n.filterAndSortCattle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (_filter.hasActiveFilters ||
                    _filter.sortOption != CattleSortOption.recentlyAdded)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filter.reset();
                      });
                    },
                    child: Text(l10n.resetAll),
                  ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Scrollable Filter Sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: <Widget>[
                // 1. Sort Options
                _buildSectionHeader(l10n.sortOrder, icon: Icons.sort),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: CattleSortOption.values.map((CattleSortOption opt) {
                    return _buildChoiceChip(
                      label: opt.localizedLabel(context),
                      isSelected: _filter.sortOption == opt,
                      onSelected: () {
                        setState(() {
                          _filter.sortOption = opt;
                        });
                      },
                    );
                  }).toList(),
                ),

                // 2. Sex
                _buildSectionHeader(l10n.sexLabel, icon: Icons.transgender),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: <String>['Female', 'Male'].map((String sex) {
                    return _buildChip(
                      label: LocalizedLabels.sex(context, sex),
                      isSelected: _filter.selectedSexes.contains(sex),
                      onSelected: () => _toggleSetItem(_filter.selectedSexes, sex),
                    );
                  }).toList(),
                ),

                // 3. Life Stage
                _buildSectionHeader(l10n.lifeStageLabel, icon: Icons.timeline),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: <String>['Calf', 'Heifer', 'Steer', 'Unknown'].map((String stage) {
                    return _buildChip(
                      label: LocalizedLabels.lifeStage(context, stage),
                      isSelected: _filter.selectedLifeStages.contains(stage),
                      onSelected: () => _toggleSetItem(_filter.selectedLifeStages, stage),
                    );
                  }).toList(),
                ),

                // 4. Health Status
                _buildSectionHeader(l10n.healthStatusLabel, icon: Icons.favorite),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: <String>[
                    'Healthy',
                    'Under Observation',
                    'Diseased',
                    'Recovered',
                    'Unknown',
                  ].map((String status) {
                    Color? activeColor;
                    if (status == 'Healthy' || status == 'Recovered') {
                      activeColor = const Color(0xFF2E7D32);
                    } else if (status == 'Under Observation') {
                      activeColor = const Color(0xFFE65100);
                    } else if (status == 'Diseased') {
                      activeColor = const Color(0xFFC62828);
                    }
                    return _buildChip(
                      label: LocalizedLabels.healthStatus(context, status),
                      activeColor: activeColor,
                      isSelected: _filter.selectedHealthStatuses.contains(status),
                      onSelected: () =>
                          _toggleSetItem(_filter.selectedHealthStatuses, status),
                    );
                  }).toList(),
                ),

                // 5. Reproductive Status
                _buildSectionHeader(l10n.reproductiveStatusLabel, icon: Icons.pregnant_woman),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: <String>['Pregnant', 'Not Pregnant', 'Unknown'].map((String repro) {
                    Color? activeColor;
                    if (repro == 'Pregnant') {
                      activeColor = const Color(0xFF8E24AA);
                    }
                    return _buildChip(
                      label: LocalizedLabels.reproductiveStatus(context, repro),
                      activeColor: activeColor,
                      isSelected: _filter.selectedReproductiveStatuses.contains(repro),
                      onSelected: () =>
                          _toggleSetItem(_filter.selectedReproductiveStatuses, repro),
                    );
                  }).toList(),
                ),

                // 6. Vaccination Status
                _buildSectionHeader(l10n.vaccinationStatusLabel, icon: Icons.vaccines),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: <String>[
                    'Up to Date',
                    'Due Soon',
                    'Overdue',
                    'No Record',
                  ].map((String vax) {
                    Color? activeColor;
                    if (vax == 'Up to Date') {
                      activeColor = const Color(0xFF2E7D32);
                    } else if (vax == 'Due Soon') {
                      activeColor = const Color(0xFFF57F17);
                    } else if (vax == 'Overdue') {
                      activeColor = const Color(0xFFC62828);
                    }
                    return _buildChip(
                      label: LocalizedLabels.vaccinationStatus(context, vax),
                      activeColor: activeColor,
                      isSelected: _filter.selectedVaccinationStatuses.contains(vax),
                      onSelected: () =>
                          _toggleSetItem(_filter.selectedVaccinationStatuses, vax),
                    );
                  }).toList(),
                ),

                // 7. Milk & Lactation Status
                _buildSectionHeader(l10n.milkAndLactation, icon: Icons.water_drop_outlined),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: <String>[
                    'Milking Cows',
                    'Dry Cows',
                    'High Producers (>15 L/day)',
                    'Medium Producers (8–15 L/day)',
                    'Low Producers (<8 L/day)',
                    'Recently Calved',
                  ].map((String milkStatus) {
                    Color? activeColor;
                    if (milkStatus.contains('High')) {
                      activeColor = const Color(0xFF2E7D32);
                    } else if (milkStatus.contains('Medium')) {
                      activeColor = const Color(0xFF1976D2);
                    } else if (milkStatus.contains('Low')) {
                      activeColor = const Color(0xFFE65100);
                    } else if (milkStatus == 'Milking Cows') {
                      activeColor = const Color(0xFF2D6A4F);
                    } else if (milkStatus == 'Dry Cows') {
                      activeColor = const Color(0xFF795548);
                    } else {
                      activeColor = const Color(0xFF6A1B9A);
                    }
                    return _buildChip(
                      label: LocalizedLabels.milkStatus(context, milkStatus),
                      activeColor: activeColor,
                      isSelected: _filter.selectedMilkStatuses.contains(milkStatus),
                      onSelected: () =>
                          _toggleSetItem(_filter.selectedMilkStatuses, milkStatus),
                    );
                  }).toList(),
                ),

                // 8. Breed
                _buildSectionHeader(l10n.breedCategory, icon: Icons.category),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _availableBreeds.map((String breed) {
                    return _buildChip(
                      label: breed == 'Unknown' ? l10n.unknown : breed,
                      isSelected: _filter.selectedBreeds.contains(breed),
                      onSelected: () => _toggleSetItem(_filter.selectedBreeds, breed),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Action Button
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6A4F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(_filter);
                },
                icon: const Icon(Icons.check),
                label: Text(
                  l10n.showMatchingCattle(matching),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

