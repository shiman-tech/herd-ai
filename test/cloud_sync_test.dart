import 'package:flutter_test/flutter_test.dart';
import 'package:herd_ai/models/cattle_record.dart';
import 'package:herd_ai/models/farm_profile.dart';
import 'package:herd_ai/models/milk_record.dart';
import 'package:herd_ai/services/supabase_sync_backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FarmProfile Model Tests', () {
    test('generateFarmId creates valid HERD-XXXXXX format', () {
      final String farmId = FarmProfile.generateFarmId();
      expect(farmId.startsWith('HERD-'), isTrue);
      expect(farmId.length, 11); // 'HERD-' (5) + 6 digits
    });

    test('serialization and deserialization roundtrip', () {
      final DateTime now = DateTime.now();
      final FarmProfile profile = FarmProfile(
        farmId: 'HERD-123456',
        phoneNumber: '+919876543210',
        pinHash: 'dummy_hash',
        lastSyncedAt: now,
        isAutoSyncEnabled: true,
        totalCattle: 5,
        totalMilkRecords: 20,
      );

      final Map<String, dynamic> map = profile.toMap();
      final FarmProfile restored = FarmProfile.fromMap(map);

      expect(restored.farmId, 'HERD-123456');
      expect(restored.phoneNumber, '+919876543210');
      expect(restored.pinHash, 'dummy_hash');
      expect(restored.isAutoSyncEnabled, isTrue);
      expect(restored.totalCattle, 5);
      expect(restored.totalMilkRecords, 20);
    });

    test('copyWith updates properties correctly', () {
      final FarmProfile profile = FarmProfile(farmId: 'HERD-111111');
      final FarmProfile updated = profile.copyWith(
        phoneNumber: '+919999999999',
        isAutoSyncEnabled: false,
      );

      expect(updated.farmId, 'HERD-111111');
      expect(updated.phoneNumber, '+919999999999');
      expect(updated.isAutoSyncEnabled, isFalse);
    });
  });

  group('Cloud Sync Data Serialization Tests', () {
    test('CattleRecord serialization for cloud upload and restore', () {
      final DateTime now = DateTime.now();
      final CattleRecord cow = CattleRecord(
        id: 'COW-CLOUD-01',
        registrationDate: now,
        sex: 'Female',
        breedName: 'Gir',
        isMilking: true,
        isPregnant: true,
        expectedDailyYield: 14.5,
      );

      final Map<String, dynamic> json = cow.toJson();
      final CattleRecord restored = CattleRecord.fromJson(json);

      expect(restored.id, 'COW-CLOUD-01');
      expect(restored.breedName, 'Gir');
      expect(restored.sex, 'Female');
      expect(restored.isMilking, isTrue);
      expect(restored.isPregnant, isTrue);
      expect(restored.expectedDailyYield, 14.5);
    });

    test('MilkRecord serialization for cloud upload and restore', () {
      final DateTime now = DateTime.now();
      final MilkRecord milk = MilkRecord(
        id: 'MILK-CLOUD-01',
        cattleId: 'COW-CLOUD-01',
        date: now,
        morningYield: 8.5,
        eveningYield: 6.5,
        createdAt: now,
        notes: 'Normal grazing',
      );

      final Map<String, dynamic> map = milk.toMap();
      final MilkRecord restored = MilkRecord.fromMap(map);

      expect(restored.id, 'MILK-CLOUD-01');
      expect(restored.cattleId, 'COW-CLOUD-01');
      expect(restored.totalYield, 15.0);
      expect(restored.notes, 'Normal grazing');
    });

    test('SupabaseSyncBackend initializes successfully with sanitized URL', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final bool ok = await SupabaseSyncBackend.instance.initialize();
      expect(ok, isTrue);
      expect(SupabaseSyncBackend.instance.isAvailable, isTrue);
    });
  });
}
