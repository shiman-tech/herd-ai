import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cattle_record.dart';
import '../models/farm_profile.dart';
import '../models/milk_record.dart';

/// Low-level Supabase adapter for Cloud Sync.
/// Handles PostgreSQL tables, Storage bucket images, and Phone Auth safely.
/// Gracefully handles offline and unconfigured environments.
class SupabaseSyncBackend {
  SupabaseSyncBackend._();
  static final SupabaseSyncBackend instance = SupabaseSyncBackend._();

  static const String _prefUrlKey = 'supabase_project_url';
  static const String _prefAnonKey = 'supabase_anon_key';
  static const String storageBucketName = 'cattle-photos';

  // Default credentials (can be overridden via SharedPreferences or configureCredentials)
  static const String defaultUrl = '';
  static const String defaultAnonKey = '';

  bool _isInitialized = false;

  bool get isAvailable => _isInitialized;

  SupabaseClient? get _client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Initializes Supabase safely with graceful fallback.
  Future<bool> initialize({String? customUrl, String? customAnonKey}) async {
    if (_isInitialized) return true;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = (customUrl ?? prefs.getString(_prefUrlKey) ?? defaultUrl).trim();
    final String anonKey = (customAnonKey ?? prefs.getString(_prefAnonKey) ?? defaultAnonKey).trim();

    if (url.isEmpty || anonKey.isEmpty) {
      _isInitialized = false;
      debugPrint('[SupabaseSyncBackend] Supabase not configured (URL or anon key is empty).');
      return false;
    }

    try {
      await Supabase.initialize(
        url: url,
        // ignore: deprecated_member_use
        anonKey: anonKey,
      );
      _isInitialized = true;
      debugPrint('[SupabaseSyncBackend] Supabase initialized successfully.');
      return true;
    } catch (e) {
      _isInitialized = false;
      debugPrint('[SupabaseSyncBackend] Supabase initialization failed: $e');
      return false;
    }
  }

  /// Saves custom credentials and re-initializes.
  Future<bool> configureCredentials({required String url, required String anonKey}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefUrlKey, url.trim());
    await prefs.setString(_prefAnonKey, anonKey.trim());
    _isInitialized = false;
    return initialize(customUrl: url, customAnonKey: anonKey);
  }

  Future<Map<String, String>> getSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return <String, String>{
      'url': prefs.getString(_prefUrlKey) ?? defaultUrl,
      'anonKey': prefs.getString(_prefAnonKey) ?? defaultAnonKey,
    };
  }

  // ---------------------------------------------------------------------------
  // Farm Profile Management
  // ---------------------------------------------------------------------------

  Future<bool> saveFarmProfile(FarmProfile profile) async {
    final SupabaseClient? client = _client;
    if (client == null) return false;

    try {
      await client.from('farms').upsert(<String, dynamic>{
        'farm_id': profile.farmId,
        'pin_hash': profile.pinHash,
        'phone_number': profile.phoneNumber,
        'total_cattle': profile.totalCattle,
        'total_milk_records': profile.totalMilkRecords,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error saving farm profile: $e');
      return false;
    }
  }

  Future<FarmProfile?> fetchFarmProfile(String farmId) async {
    final SupabaseClient? client = _client;
    if (client == null) return null;

    try {
      final Map<String, dynamic>? data = await client
          .from('farms')
          .select()
          .eq('farm_id', farmId)
          .maybeSingle();

      if (data == null) return null;

      return FarmProfile(
        farmId: data['farm_id'] as String,
        pinHash: data['pin_hash'] as String?,
        phoneNumber: data['phone_number'] as String?,
        totalCattle: (data['total_cattle'] as num?)?.toInt() ?? 0,
        totalMilkRecords: (data['total_milk_records'] as num?)?.toInt() ?? 0,
        lastSyncedAt: data['updated_at'] != null ? DateTime.tryParse(data['updated_at'] as String) : null,
      );
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error fetching farm profile: $e');
      return null;
    }
  }

  Future<FarmProfile?> findFarmByPhone(String phoneNumber) async {
    final SupabaseClient? client = _client;
    if (client == null) return null;

    try {
      final String cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');
      final Map<String, dynamic>? data = await client
          .from('farms')
          .select()
          .eq('phone_number', cleanPhone)
          .maybeSingle();

      if (data == null) return null;

      return FarmProfile(
        farmId: data['farm_id'] as String,
        pinHash: data['pin_hash'] as String?,
        phoneNumber: data['phone_number'] as String?,
        totalCattle: (data['total_cattle'] as num?)?.toInt() ?? 0,
        totalMilkRecords: (data['total_milk_records'] as num?)?.toInt() ?? 0,
        lastSyncedAt: data['updated_at'] != null ? DateTime.tryParse(data['updated_at'] as String) : null,
      );
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error finding farm by phone: $e');
      return null;
    }
  }

  Future<String?> findFarmIdByPhone(String phoneNumber) async {
    final FarmProfile? profile = await findFarmByPhone(phoneNumber);
    return profile?.farmId;
  }

  Future<bool> verifyFarmPin(String farmId, String pinHash) async {
    final FarmProfile? profile = await fetchFarmProfile(farmId);
    if (profile == null) return false;
    return profile.pinHash == pinHash;
  }

  // ---------------------------------------------------------------------------
  // Cattle Record Synchronization
  // ---------------------------------------------------------------------------

  Future<bool> uploadCattle(String farmId, CattleRecord cattle) async {
    final SupabaseClient? client = _client;
    if (client == null) return false;

    try {
      await client.from('cattle').upsert(<String, dynamic>{
        'id': cattle.id,
        'farm_id': farmId,
        'data': cattle.toJson(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error uploading cattle ${cattle.id}: $e');
      return false;
    }
  }

  Future<bool> uploadMilkRecord(String farmId, MilkRecord record) async {
    final SupabaseClient? client = _client;
    if (client == null) return false;

    try {
      await client.from('milk_records').upsert(<String, dynamic>{
        'id': record.id,
        'farm_id': farmId,
        'cattle_id': record.cattleId,
        'date': record.date.toIso8601String(),
        'data': record.toMap(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error uploading milk record ${record.id}: $e');
      return false;
    }
  }

  Future<bool> deleteRemoteEntity(String farmId, String entityType, String entityId) async {
    final SupabaseClient? client = _client;
    if (client == null) return false;

    try {
      if (entityType == 'cattle') {
        await client.from('cattle').delete().eq('farm_id', farmId).eq('id', entityId);
      } else if (entityType == 'milk_record') {
        await client.from('milk_records').delete().eq('farm_id', farmId).eq('id', entityId);
      }
      return true;
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error deleting remote entity $entityType/$entityId: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchRemoteCattle(String farmId) async {
    final SupabaseClient? client = _client;
    if (client == null) return <Map<String, dynamic>>[];

    try {
      final List<dynamic> rows = await client
          .from('cattle')
          .select('data')
          .eq('farm_id', farmId);

      return rows.map((dynamic r) {
        final Map<dynamic, dynamic> map = r['data'] as Map<dynamic, dynamic>;
        return Map<String, dynamic>.from(map);
      }).toList();
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error fetching remote cattle: $e');
      return <Map<String, dynamic>>[];
    }
  }

  Future<List<Map<String, dynamic>>> fetchRemoteMilkRecords(String farmId) async {
    final SupabaseClient? client = _client;
    if (client == null) return <Map<String, dynamic>>[];

    try {
      final List<dynamic> rows = await client
          .from('milk_records')
          .select('data')
          .eq('farm_id', farmId);

      return rows.map((dynamic r) {
        final Map<dynamic, dynamic> map = r['data'] as Map<dynamic, dynamic>;
        return Map<String, dynamic>.from(map);
      }).toList();
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error fetching remote milk records: $e');
      return <Map<String, dynamic>>[];
    }
  }

  // ---------------------------------------------------------------------------
  // Image Storage Management (Supabase Storage Bucket: 'cattle-photos')
  // ---------------------------------------------------------------------------

  Future<String?> uploadImageFile(String farmId, String fileName, File file) async {
    final SupabaseClient? client = _client;
    if (client == null) return null;

    try {
      final String storagePath = '$farmId/$fileName';
      final Uint8List bytes = await file.readAsBytes();
      await client.storage.from(storageBucketName).uploadBinary(
            storagePath,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );
      return client.storage.from(storageBucketName).getPublicUrl(storagePath);
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error uploading image $fileName: $e');
      return null;
    }
  }

  Future<bool> downloadImageFile(String farmId, String fileName, File destination) async {
    final SupabaseClient? client = _client;
    if (client == null) return false;

    try {
      final String storagePath = '$farmId/$fileName';
      final Uint8List bytes = await client.storage.from(storageBucketName).download(storagePath);
      await destination.writeAsBytes(bytes);
      return true;
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error downloading image $fileName: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Phone Authentication (SMS OTP via Supabase Auth)
  // ---------------------------------------------------------------------------

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) async {
    final SupabaseClient? client = _client;
    if (client == null) {
      onError('Supabase authentication service is not configured.');
      return;
    }

    try {
      final String cleanPhone = phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';
      await client.auth.signInWithOtp(phone: cleanPhone);
      onCodeSent(cleanPhone);
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error sending phone OTP: $e');
      onError(e.toString());
    }
  }

  Future<bool> verifyOtp({
    required String verificationId,
    required String smsCode,
    String? phoneNumber,
  }) async {
    final SupabaseClient? client = _client;
    if (client == null) return false;

    try {
      final String targetPhone = phoneNumber ?? verificationId;
      final String cleanPhone = targetPhone.startsWith('+') ? targetPhone : '+91$targetPhone';
      final AuthResponse response = await client.auth.verifyOTP(
        phone: cleanPhone,
        token: smsCode.trim(),
        type: OtpType.sms,
      );
      return response.user != null;
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] OTP verification error: $e');
      return false;
    }
  }
}
