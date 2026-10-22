import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  static const String defaultUrl = 'https://zdptkzhcpgnchigshzbk.supabase.co';
  static const String defaultAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpkcHRremhjcGduY2hpZ3NoemJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI2NDE5MTQsImV4cCI6MjEwODIxNzkxNH0.Klse8mhuobkIRB2bVi5GVgTBde9VYlvFm3-EGP__yFM';

  static const String storageBucketName = 'cattle-photos';

  bool _isInitialized = false;
  bool _bucketChecked = false;

  bool get isAvailable => _isInitialized;

  SupabaseClient? get _client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Initializes Supabase from .env, local file, or environment with graceful fallback.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    // Check if Supabase client is already active
    try {
      final SupabaseClient current = Supabase.instance.client;
      if (current.rest.url.isNotEmpty) {
        _isInitialized = true;
        return true;
      }
    } catch (_) {}

    String url = '';
    String anonKey = '';

    // 1. Try loading from .env via flutter_dotenv
    try {
      if (!dotenv.isInitialized) {
        await dotenv.load(fileName: '.env');
      }
      url = (dotenv.maybeGet('SUPABASE_URL') ?? '').trim();
      anonKey = (dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '').trim();
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] .env asset not loaded: $e');
    }

    // 2. Direct file fallback (for running on macOS/Linux/Windows debug)
    if (url.isEmpty || anonKey.isEmpty) {
      try {
        final File envFile = File('.env');
        if (envFile.existsSync()) {
          final List<String> lines = await envFile.readAsLines();
          for (final String line in lines) {
            final String trimmed = line.trim();
            if (trimmed.startsWith('SUPABASE_URL=')) {
              url = trimmed.substring('SUPABASE_URL='.length).trim();
            } else if (trimmed.startsWith('SUPABASE_ANON_KEY=')) {
              anonKey = trimmed.substring('SUPABASE_ANON_KEY='.length).trim();
            }
          }
        }
      } catch (_) {}
    }

    // 3. Fallback to --dart-define environment variables
    if (url.isEmpty) {
      url = const String.fromEnvironment('SUPABASE_URL').trim();
    }
    if (anonKey.isEmpty) {
      anonKey = const String.fromEnvironment('SUPABASE_ANON_KEY').trim();
    }

    // 4. Fallback to default constants
    if (url.isEmpty) {
      url = defaultUrl;
    }
    if (anonKey.isEmpty) {
      anonKey = defaultAnonKey;
    }

    // Sanitize URL: strip trailing /rest/v1 or /rest/v1/ or trailing /
    url = url.replaceAll(RegExp(r'/rest/v1/?$'), '').replaceAll(RegExp(r'/+$'), '');
    anonKey = anonKey.replaceAll('"', '').replaceAll("'", '').trim();

    if (url.isEmpty || anonKey.isEmpty) {
      _isInitialized = false;
      debugPrint('[SupabaseSyncBackend] Supabase credentials missing.');
      return false;
    }

    try {
      await Supabase.initialize(
        url: url,
        // ignore: deprecated_member_use
        anonKey: anonKey,
      );
      _isInitialized = true;
      debugPrint('[SupabaseSyncBackend] Supabase initialized successfully with $url.');
      return true;
    } catch (e) {
      if (e.toString().toLowerCase().contains('already initialized') ||
          e.toString().toLowerCase().contains('already been initialized')) {
        _isInitialized = true;
        debugPrint('[SupabaseSyncBackend] Supabase was already initialized.');
        return true;
      }
      _isInitialized = false;
      debugPrint('[SupabaseSyncBackend] Supabase initialization failed: $e');
      return false;
    }
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

  Future<void> _ensureBucketExists() async {
    if (_bucketChecked) return;
    final SupabaseClient? client = _client;
    if (client == null) return;
    try {
      final List<Bucket> buckets = await client.storage.listBuckets();
      final bool exists = buckets.any((Bucket b) => b.name == storageBucketName || b.id == storageBucketName);
      if (!exists) {
        await client.storage.createBucket(
          storageBucketName,
          const BucketOptions(public: true),
        );
      }
    } catch (_) {}
    _bucketChecked = true;
  }

  Future<String?> uploadImageFile(String farmId, String fileName, File file) async {
    final SupabaseClient? client = _client;
    if (client == null) return null;

    try {
      await _ensureBucketExists();
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
      debugPrint('[SupabaseSyncBackend] Warning: image upload failed for $fileName: $e');
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
