import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/cattle_image.dart';
import '../models/cattle_record.dart';
import '../models/farm_profile.dart';
import '../models/milk_record.dart';
import 'app_auth_service.dart';
import 'embedding_database.dart';
import 'supabase_sync_backend.dart';

enum SyncStatus {
  idle,
  syncing,
  synced,
  offline,
  error,
  unconfigured,
}

class CloudSyncService extends ChangeNotifier {
  CloudSyncService._({
    SupabaseSyncBackend? backend,
    FlutterSecureStorage? secureStorage,
    EmbeddingDatabase? database,
    Connectivity? connectivity,
  })  : _backend = backend ?? SupabaseSyncBackend.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _database = database ?? EmbeddingDatabase.instance,
        _connectivity = connectivity ?? Connectivity();

  static final CloudSyncService instance = CloudSyncService._();

  final SupabaseSyncBackend _backend;
  final FlutterSecureStorage _secureStorage;
  final EmbeddingDatabase _database;
  final Connectivity _connectivity;

  static const String _farmIdKey = 'cloud_sync_farm_id';
  static const String _phoneKey = 'cloud_sync_phone';
  static const String _lastSyncedKey = 'cloud_sync_last_synced';
  static const String _autoSyncKey = 'cloud_sync_auto_enabled';

  FarmProfile? _profile;
  SyncStatus _status = SyncStatus.idle;
  String? _lastError;
  bool _isOnline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _debounceTimer;

  FarmProfile? get profile => _profile;
  SyncStatus get status => _status;
  String? get lastError => _lastError;
  bool get isOnline => _isOnline;
  bool get isSyncing => _status == SyncStatus.syncing;

  // ---------------------------------------------------------------------------
  // Lifecycle & Initialization
  // ---------------------------------------------------------------------------

  Future<void> initialize() async {
    await _loadLocalProfile();
    final bool backendOk = await _backend.initialize();

    // Check initial connectivity
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _isOnline = _hasConnection(results);
    } catch (_) {
      _isOnline = false;
    }

    if (!backendOk) {
      _status = SyncStatus.unconfigured;
    } else if (!_isOnline) {
      _status = SyncStatus.offline;
    } else {
      _status = SyncStatus.idle;
    }
    notifyListeners();

    // Listen to network transitions
    _connectivitySub = _connectivity.onConnectivityChanged.listen(_handleConnectivityChanged);

    // Auto-sync on startup if online and enabled
    if (_isOnline && (_profile?.isAutoSyncEnabled ?? true) && backendOk) {
      syncNow();
    }
  }

  void _handleConnectivityChanged(List<ConnectivityResult> results) {
    final bool nowOnline = _hasConnection(results);
    final bool transitionedToOnline = !_isOnline && nowOnline;
    _isOnline = nowOnline;

    if (!nowOnline) {
      if (_status != SyncStatus.syncing) {
        _status = SyncStatus.offline;
        notifyListeners();
      }
      return;
    }

    if (transitionedToOnline && (_profile?.isAutoSyncEnabled ?? true)) {
      _debounceTimer?.cancel();
      // Debounce 4 seconds to allow network to stabilize
      _debounceTimer = Timer(const Duration(seconds: 4), () {
        syncNow();
      });
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return true;
    return results.any((ConnectivityResult r) => r != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _connectivitySub?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Profile Storage
  // ---------------------------------------------------------------------------

  Future<void> _loadLocalProfile() async {
    String? farmId = await _secureStorage.read(key: _farmIdKey);
    if (farmId == null || farmId.isEmpty) {
      farmId = FarmProfile.generateFarmId();
      await _secureStorage.write(key: _farmIdKey, value: farmId);
    }

    final String? phone = await _secureStorage.read(key: _phoneKey);
    final String? lastSyncStr = await _secureStorage.read(key: _lastSyncedKey);
    final String? autoSyncStr = await _secureStorage.read(key: _autoSyncKey);

    DateTime? lastSync;
    if (lastSyncStr != null && lastSyncStr.isNotEmpty) {
      lastSync = DateTime.tryParse(lastSyncStr);
    }

    final bool autoSync = autoSyncStr != 'false';

    // Get current PIN hash from AppAuthService
    final String? pinHash = await AppAuthService().getPin();

    _profile = FarmProfile(
      farmId: farmId,
      phoneNumber: phone,
      pinHash: pinHash,
      lastSyncedAt: lastSync,
      isAutoSyncEnabled: autoSync,
      totalCattle: _database.totalCattle,
      totalMilkRecords: _database.getAllMilkRecords().length,
    );
  }

  Future<void> setFarmId(String farmId) async {
    await _secureStorage.write(key: _farmIdKey, value: farmId);
    _profile = _profile?.copyWith(farmId: farmId);
    notifyListeners();
  }

  Future<void> setPhoneNumber(String phone) async {
    String clean = phone.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!clean.startsWith('+')) {
      if (clean.startsWith('0')) {
        clean = '+91${clean.substring(1)}';
      } else if (clean.length == 10) {
        clean = '+91$clean';
      }
    }
    await _secureStorage.write(key: _phoneKey, value: clean);
    _profile = _profile?.copyWith(phoneNumber: clean);
    notifyListeners();

    if (!_backend.isAvailable) {
      await _backend.initialize();
    }
    if (_backend.isAvailable && _profile != null) {
      await _backend.saveFarmProfile(_profile!);
    }
  }

  Future<void> toggleAutoSync(bool enabled) async {
    await _secureStorage.write(key: _autoSyncKey, value: enabled.toString());
    _profile = _profile?.copyWith(isAutoSyncEnabled: enabled);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Synchronization (Local -> Cloud & Remote Tombstones)
  // ---------------------------------------------------------------------------

  Future<bool> syncNow({bool force = false}) async {
    if (_status == SyncStatus.syncing) {
      return false;
    }

    if (!_backend.isAvailable) {
      final bool backendOk = await _backend.initialize();
      if (!backendOk) {
        _status = SyncStatus.unconfigured;
        _lastError = 'Cloud sync is not configured. Please check SUPABASE_URL and SUPABASE_ANON_KEY in .env.';
        notifyListeners();
        return false;
      }
    }

    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _isOnline = _hasConnection(results);
    } catch (_) {
      if (force) _isOnline = true;
    }

    if (!_isOnline && !force) {
      _status = SyncStatus.offline;
      _lastError = 'Device is currently offline.';
      notifyListeners();
      return false;
    }

    _status = SyncStatus.syncing;
    _lastError = null;
    notifyListeners();

    try {
      if (_profile == null) {
        await _loadLocalProfile();
      }

      final String farmId = _profile!.farmId;

      // Update PIN hash in profile
      final String? currentPinHash = await AppAuthService().getPin();
      _profile = _profile!.copyWith(
        pinHash: currentPinHash,
        totalCattle: _database.totalCattle,
        totalMilkRecords: _database.getAllMilkRecords().length,
      );

      // 1. Upload/Update Farm Profile Document
      await _backend.saveFarmProfile(_profile!);

      // 2. Synchronize Tombstones (Delete removed records in the cloud)
      final List<Map<String, String>> tombstones = await _database.getTombstones();
      final List<String> clearedIds = <String>[];
      for (final Map<String, String> tomb in tombstones) {
        final String entityType = tomb['entity_type'] ?? '';
        final String entityId = tomb['entity_id'] ?? '';
        if (entityId.isNotEmpty) {
          final bool deleted = await _backend.deleteRemoteEntity(farmId, entityType, entityId);
          if (deleted) {
            clearedIds.add(entityId);
          }
        }
      }
      if (clearedIds.isNotEmpty) {
        await _database.clearTombstones(clearedIds);
      }

      // 3. Synchronize Cattle Records and Photos
      final List<CattleRecord> allCattle = _database.getAllCattle();
      for (final CattleRecord cattle in allCattle) {
        // Upload any local photos to cloud storage (compressed)
        for (final CattleImage imgRecord in cattle.images) {
          final File localFile = File(imgRecord.path);
          if (localFile.existsSync()) {
            final String fileName = p.basename(imgRecord.path);
            await _uploadCompressedImageIfNeeded(farmId, fileName, localFile);
          }
        }
        await _backend.uploadCattle(farmId, cattle);
      }

      // 4. Synchronize Milk Records
      final List<MilkRecord> allMilk = _database.getAllMilkRecords();
      for (final MilkRecord milk in allMilk) {
        await _backend.uploadMilkRecord(farmId, milk);
      }

      // 5. Update last synced timestamp
      final DateTime now = DateTime.now();
      _profile = _profile!.copyWith(lastSyncedAt: now);
      await _secureStorage.write(key: _lastSyncedKey, value: now.toIso8601String());
      await _backend.saveFarmProfile(_profile!);

      _status = SyncStatus.synced;
      notifyListeners();
      return true;
    } catch (e) {
      _status = SyncStatus.error;
      _lastError = e.toString();
      debugPrint('[CloudSyncService] Sync failed: $e');
      notifyListeners();
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Restoration (Cloud -> New Device)
  // ---------------------------------------------------------------------------

  /// Restores farm using Farm Code & 4-Digit PIN.
  /// Used when farmer lost device and does not have active SIM.
  Future<bool> restoreWithFarmCodeAndPin({
    required String farmId,
    required String pin,
  }) async {
    if (!_backend.isAvailable) {
      _lastError = 'Cloud service is not initialized.';
      notifyListeners();
      return false;
    }

    _status = SyncStatus.syncing;
    _lastError = null;
    notifyListeners();

    try {
      // 1. Fetch remote profile
      final FarmProfile? remoteProfile = await _backend.fetchFarmProfile(farmId.trim().toUpperCase());
      if (remoteProfile == null) {
        _status = SyncStatus.error;
        _lastError = _backend.lastFetchError ?? 'Farm not found with code: $farmId';
        notifyListeners();
        return false;
      }

      // 2. Validate PIN Hash
      final String inputHash = _hashPin(pin);
      if (remoteProfile.pinHash != null && remoteProfile.pinHash != inputHash) {
        _status = SyncStatus.error;
        _lastError = 'Incorrect PIN for this Farm Code.';
        notifyListeners();
        return false;
      }

      // 3. Download and merge records
      final bool restored = await _pullAndRestoreFarmData(remoteProfile.farmId);
      if (!restored) {
        _status = SyncStatus.error;
        notifyListeners();
        return false;
      }

      // 4. Save local PIN and Farm ID
      await AppAuthService().savePin(pin);
      await setFarmId(remoteProfile.farmId);
      if (remoteProfile.phoneNumber != null) {
        await _secureStorage.write(key: _phoneKey, value: remoteProfile.phoneNumber);
      }

      _profile = remoteProfile.copyWith(lastSyncedAt: DateTime.now());
      _status = SyncStatus.synced;
      notifyListeners();
      return true;
    } catch (e) {
      _status = SyncStatus.error;
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Restores farm using Phone Number and SMS OTP.
  Future<bool> restoreWithPhoneOtp({
    required String phoneNumber,
    required String verificationId,
    required String smsCode,
    String? localPin,
  }) async {
    if (!_backend.isAvailable) {
      _lastError = 'Cloud service is not initialized.';
      notifyListeners();
      return false;
    }

    _status = SyncStatus.syncing;
    _lastError = null;
    notifyListeners();

    try {
      // 1. Verify SMS OTP
      final bool verified = await _backend.verifyOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      if (!verified) {
        _status = SyncStatus.error;
        _lastError = 'Invalid verification code.';
        notifyListeners();
        return false;
      }

      // 2. Find Farm ID associated with this phone number
      final String? farmId = await _backend.findFarmIdByPhone(phoneNumber);
      if (farmId == null) {
        _status = SyncStatus.error;
        _lastError = _backend.lastFetchError ?? 'No farm found registered with this phone number.';
        notifyListeners();
        return false;
      }

      final FarmProfile? remoteProfile = await _backend.fetchFarmProfile(farmId);
      if (remoteProfile == null) {
        _status = SyncStatus.error;
        _lastError = _backend.lastFetchError ?? 'Farm profile could not be loaded.';
        notifyListeners();
        return false;
      }

      // 3. Pull and restore data
      final bool restored = await _pullAndRestoreFarmData(farmId);
      if (!restored) {
        _status = SyncStatus.error;
        notifyListeners();
        return false;
      }

      // 4. Set local PIN
      if (localPin != null && localPin.isNotEmpty) {
        await AppAuthService().savePin(localPin);
      }

      await setFarmId(farmId);
      await setPhoneNumber(phoneNumber);

      _profile = remoteProfile.copyWith(lastSyncedAt: DateTime.now());
      _status = SyncStatus.synced;
      notifyListeners();
      return true;
    } catch (e) {
      _status = SyncStatus.error;
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Restoration Internals
  // ---------------------------------------------------------------------------

  Future<bool> _pullAndRestoreFarmData(String farmId) async {
    final Directory docs = await getApplicationDocumentsDirectory();
    final Directory imageDir = Directory(p.join(docs.path, 'cattle_images'));
    if (!imageDir.existsSync()) {
      await imageDir.create(recursive: true);
    }

    // 1. Pull Remote Cattle
    final List<Map<String, dynamic>> cattleDocs = await _backend.fetchRemoteCattle(farmId);
    for (final Map<String, dynamic> cMap in cattleDocs) {
      final CattleRecord cattle = CattleRecord.fromJson(cMap);

      // Download and remap images locally
      final List<CattleImage> localImages = <CattleImage>[];
      for (final CattleImage imgItem in cattle.images) {
        final String fileName = p.basename(imgItem.path);
        final File localFile = File(p.join(imageDir.path, fileName));

        if (!localFile.existsSync()) {
          await _backend.downloadImageFile(farmId, fileName, localFile);
        }

        localImages.add(CattleImage(
          id: imgItem.id,
          path: localFile.path,
          uploadedAt: imgItem.uploadedAt,
        ));
      }

      // Remap profile image path locally
      String? localProfilePath;
      if (cattle.profileImagePath != null) {
        final String profileName = p.basename(cattle.profileImagePath!);
        final File profileFile = File(p.join(imageDir.path, profileName));
        if (profileFile.existsSync()) {
          localProfilePath = profileFile.path;
        } else if (localImages.isNotEmpty) {
          localProfilePath = localImages.first.path;
        }
      }

      cattle.images
        ..clear()
        ..addAll(localImages);
      cattle.profileImagePath = localProfilePath;

      await _database.importCattleFromCloud(cattle);
    }

    // 2. Pull Remote Milk Records
    final List<Map<String, dynamic>> milkDocs = await _backend.fetchRemoteMilkRecords(farmId);
    for (final Map<String, dynamic> mMap in milkDocs) {
      final MilkRecord record = MilkRecord.fromMap(mMap);
      await _database.importMilkRecordFromCloud(record);
    }

    return true;
  }

  // ---------------------------------------------------------------------------
  // Image Compression & Upload Helper
  // ---------------------------------------------------------------------------

  Future<void> _uploadCompressedImageIfNeeded(
    String farmId,
    String fileName,
    File localFile,
  ) async {
    try {
      // Compress to high-efficiency JPEG (max 1280px dimension, 85% quality)
      final Uint8List bytes = await localFile.readAsBytes();
      final img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) return;

      img.Image processed = decoded;
      if (decoded.width > 1280 || decoded.height > 1280) {
        processed = img.copyResize(
          decoded,
          width: decoded.width > decoded.height ? 1280 : null,
          height: decoded.height >= decoded.width ? 1280 : null,
          interpolation: img.Interpolation.linear,
        );
      }

      final Uint8List compressedBytes = Uint8List.fromList(
        img.encodeJpg(processed, quality: 85),
      );

      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File(p.join(tempDir.path, 'sync_$fileName'));
      await tempFile.writeAsBytes(compressedBytes);

      await _backend.uploadImageFile(farmId, fileName, tempFile);
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }
    } catch (e) {
      debugPrint('[CloudSyncService] Error compressing/uploading image $fileName: $e');
    }
  }

  String _hashPin(String pin) {
    final List<int> bytes = utf8.encode(pin);
    return sha256.convert(bytes).toString();
  }
}
