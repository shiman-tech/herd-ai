import 'dart:math';

class FarmProfile {
  FarmProfile({
    required this.farmId,
    this.phoneNumber,
    this.pinHash,
    this.lastSyncedAt,
    this.isAutoSyncEnabled = true,
    this.totalCattle = 0,
    this.totalMilkRecords = 0,
  });

  final String farmId;
  String? phoneNumber;
  String? pinHash;
  DateTime? lastSyncedAt;
  bool isAutoSyncEnabled;
  int totalCattle;
  int totalMilkRecords;

  /// Generates a friendly 6-digit Farm Code like HERD-482910
  static String generateFarmId() {
    final int randomSixDigits = 100000 + Random().nextInt(900000);
    return 'HERD-$randomSixDigits';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'farmId': farmId,
      'phoneNumber': phoneNumber,
      'pinHash': pinHash,
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'isAutoSyncEnabled': isAutoSyncEnabled,
      'totalCattle': totalCattle,
      'totalMilkRecords': totalMilkRecords,
    };
  }

  factory FarmProfile.fromMap(Map<String, dynamic> map) {
    return FarmProfile(
      farmId: map['farmId'] as String? ?? generateFarmId(),
      phoneNumber: map['phoneNumber'] as String?,
      pinHash: map['pinHash'] as String?,
      lastSyncedAt: map['lastSyncedAt'] != null
          ? DateTime.tryParse(map['lastSyncedAt'] as String)
          : null,
      isAutoSyncEnabled: (map['isAutoSyncEnabled'] as bool?) ?? true,
      totalCattle: (map['totalCattle'] as num?)?.toInt() ?? 0,
      totalMilkRecords: (map['totalMilkRecords'] as num?)?.toInt() ?? 0,
    );
  }

  FarmProfile copyWith({
    String? farmId,
    String? phoneNumber,
    String? pinHash,
    DateTime? lastSyncedAt,
    bool? isAutoSyncEnabled,
    int? totalCattle,
    int? totalMilkRecords,
  }) {
    return FarmProfile(
      farmId: farmId ?? this.farmId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pinHash: pinHash ?? this.pinHash,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isAutoSyncEnabled: isAutoSyncEnabled ?? this.isAutoSyncEnabled,
      totalCattle: totalCattle ?? this.totalCattle,
      totalMilkRecords: totalMilkRecords ?? this.totalMilkRecords,
    );
  }
}
