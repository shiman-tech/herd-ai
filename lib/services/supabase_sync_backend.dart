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

  String? _lastFetchError;
  String? get lastFetchError {
    final String? err = _lastFetchError;
    _lastFetchError = null;
    return err;
  }

  static String _friendlyNetworkError(Object e) {
    final String raw = e.toString().toLowerCase();
    if (raw.contains('socket') ||
        raw.contains('network') ||
        raw.contains('connection') ||
        raw.contains('timeout') ||
        raw.contains('unreachable') ||
        raw.contains('permission denied')) {
      return 'Could not connect to cloud server. Please check your internet connection.';
    }
    return 'Could not reach cloud backup. Please try again.';
  }

  Future<FarmProfile?> fetchFarmProfile(String farmId) async {
    final SupabaseClient? client = _client;
    if (client == null) {
      _lastFetchError = 'Cloud service is not initialized.';
      return null;
    }

    try {
      _lastFetchError = null;
      final String cleanId = farmId.trim().toUpperCase();
      final Map<String, dynamic>? data = await client
          .from('farms')
          .select()
          .eq('farm_id', cleanId)
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
      _lastFetchError = _friendlyNetworkError(e);
      return null;
    }
  }

  Future<FarmProfile?> findFarmByPhone(String phoneNumber) async {
    final SupabaseClient? client = _client;
    if (client == null) {
      _lastFetchError = 'Cloud service is not initialized.';
      return null;
    }

    try {
      _lastFetchError = null;
      final String clean = phoneNumber.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
      String withPlus91 = clean;
      String rawDigits = clean;

      if (clean.startsWith('+91')) {
        rawDigits = clean.substring(3);
      } else if (clean.startsWith('+')) {
        rawDigits = clean.substring(1);
      } else if (clean.startsWith('0')) {
        rawDigits = clean.substring(1);
        withPlus91 = '+91$rawDigits';
      } else {
        withPlus91 = '+91$clean';
      }

      // Query farms with matching phone formats (+91XXXXXXXXXX or raw digits)
      final List<dynamic> rows = await client
          .from('farms')
          .select()
          .or('phone_number.eq.$withPlus91,phone_number.eq.$rawDigits,phone_number.eq.$clean')
          .limit(1);

      if (rows.isEmpty) return null;
      final Map<String, dynamic> data = Map<String, dynamic>.from(rows.first as Map);

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
      _lastFetchError = _friendlyNetworkError(e);
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

  // ---------------------------------------------------------------------------
  // Auth error helper – converts technical exceptions to farmer-friendly text
  // ---------------------------------------------------------------------------

  static String _friendlyAuthError(Object e, {bool isVerify = false}) {
    final String raw = e.toString().toLowerCase();

    debugPrint('[SupabaseSyncBackend] Auth error (raw): ${e.toString()}');

    // ---- Rate limiting (must be checked with very specific terms) ----
    if (raw.contains('rate limit') ||
        raw.contains('too many requests') ||
        raw.contains('too many') ||
        raw.contains('quota exceeded') ||
        raw.contains('status code: 429') ||
        raw.contains('429')) {
      return 'You have requested too many codes in a short time. '
          'Please wait a minute and try again.';
    }

    // ---- Twilio / SMS provider: unverified number (trial account) ----
    if (raw.contains('unverified') ||
        raw.contains('not a verified') ||
        raw.contains('trial account') ||
        raw.contains('verify') && raw.contains('twilio')) {
      return 'This phone number has not been verified on the SMS provider\'s '
          'trial account. Please contact support or use a verified number.';
    }

    // ---- SMS provider not configured / service unavailable ----
    if ((raw.contains('sms') && raw.contains('provider')) ||
        raw.contains('not configured') ||
        raw.contains('provider error') ||
        raw.contains('service unavailable') ||
        raw.contains('503') ||
        raw.contains('502')) {
      return 'The SMS service is temporarily unavailable. '
          'Please try again in a few minutes.';
    }

    // ---- Invalid / unsupported phone number ----
    if (raw.contains('invalid phone') ||
        raw.contains('invalid_phone') ||
        raw.contains('phone number') ||
        raw.contains('phone_number') ||
        raw.contains('invalid number') ||
        raw.contains('21211') || // Twilio invalid number error code
        raw.contains('21614')) {
      return 'The phone number you entered is not valid. '
          'Please include the country code (e.g. +91 for India).';
    }

    // ---- Phone not registered / not found ----
    if (raw.contains('user not found') ||
        raw.contains('no user') ||
        raw.contains('does not exist')) {
      return 'No farm backup found for this phone number. '
          'Make sure you used the same number when you set up cloud backup.';
    }

    // ---- OTP / token wrong or expired (only on verify step) ----
    if (isVerify &&
        (raw.contains('invalid') ||
            raw.contains('expired') ||
            raw.contains('token') ||
            raw.contains('otp') ||
            raw.contains('verification code'))) {
      return 'The verification code is wrong or has expired. '
          'Please request a new code and enter it quickly.';
    }

    // ---- Network / connectivity ----
    if (raw.contains('network') ||
        raw.contains('socket') ||
        raw.contains('connection') ||
        raw.contains('timeout') ||
        raw.contains('unreachable')) {
      return 'Could not reach the server. '
          'Please check your internet connection and try again.';
    }

    // ---- Generic fallback ----
    return 'Could not send the verification code. '
        'Please check your number and try again. '
        'If the problem continues, contact support.';
  }

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) async {
    final SupabaseClient? client = _client;
    if (client == null) {
      onError('Cloud service is not available right now. Please try again later.');
      return;
    }

    try {
      final String cleanPhone = phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';
      await client.auth.signInWithOtp(phone: cleanPhone);
      onCodeSent(cleanPhone);
    } catch (e) {
      debugPrint('[SupabaseSyncBackend] Error sending phone OTP: $e');
      onError(_friendlyAuthError(e));
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
      // Store friendly error so callers can surface it
      _lastVerifyError = _friendlyAuthError(e, isVerify: true);
      return false;
    }
  }

  /// Last user-friendly error from [verifyOtp], cleared on next call.
  String? _lastVerifyError;
  String? get lastVerifyError {
    final String? err = _lastVerifyError;
    _lastVerifyError = null;
    return err;
  }
}
