import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../models/cattle_record.dart';
import '../models/farm_profile.dart';
import '../models/milk_record.dart';

/// Low-level Firebase adapter for Cloud Sync.
/// Handles Firestore documents, Storage images, and Phone Auth safely.
/// Gracefully handles offline and unconfigured environments.
class FirebaseSyncBackend {
  FirebaseSyncBackend._();
  static final FirebaseSyncBackend instance = FirebaseSyncBackend._();

  bool _isInitialized = false;
  bool _initAttempted = false;

  bool get isAvailable => _isInitialized;

  FirebaseFirestore? get _firestore => _isInitialized ? FirebaseFirestore.instance : null;
  FirebaseStorage? get _storage => _isInitialized ? FirebaseStorage.instance : null;
  FirebaseAuth? get _auth => _isInitialized ? FirebaseAuth.instance : null;

  /// Initializes Firebase safely with graceful fallback.
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    if (_initAttempted) return _isInitialized;
    _initAttempted = true;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _isInitialized = true;
      debugPrint('[FirebaseSyncBackend] Firebase initialized successfully.');
      return true;
    } catch (e) {
      _isInitialized = false;
      debugPrint('[FirebaseSyncBackend] Firebase not available/configured: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Farm Profile Management
  // ---------------------------------------------------------------------------

  Future<bool> saveFarmProfile(FarmProfile profile) async {
    final FirebaseFirestore? firestore = _firestore;
    if (firestore == null) return false;

    try {
      final WriteBatch batch = firestore.batch();
      final DocumentReference<Map<String, dynamic>> profileRef =
          firestore.collection('farms').doc(profile.farmId).collection('meta').doc('profile');

      batch.set(profileRef, <String, dynamic>{
        ...profile.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (profile.phoneNumber != null && profile.phoneNumber!.trim().isNotEmpty) {
        final DocumentReference<Map<String, dynamic>> phoneRef =
            firestore.collection('phone_to_farm').doc(profile.phoneNumber!.trim());
        batch.set(phoneRef, <String, dynamic>{
          'farmId': profile.farmId,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
      return true;
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error saving farm profile: $e');
      return false;
    }
  }

  Future<FarmProfile?> fetchFarmProfile(String farmId) async {
    final FirebaseFirestore? firestore = _firestore;
    if (firestore == null) return null;

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await firestore.collection('farms').doc(farmId).collection('meta').doc('profile').get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return FarmProfile.fromMap(doc.data()!);
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error fetching farm profile: $e');
      return null;
    }
  }

  Future<String?> findFarmIdByPhone(String phoneNumber) async {
    final FirebaseFirestore? firestore = _firestore;
    if (firestore == null) return null;

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await firestore.collection('phone_to_farm').doc(phoneNumber.trim()).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return doc.data()?['farmId'] as String?;
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error finding farm by phone: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Entity Uploads
  // ---------------------------------------------------------------------------

  Future<bool> uploadCattle(String farmId, CattleRecord cattle) async {
    final FirebaseFirestore? firestore = _firestore;
    if (firestore == null) return false;

    try {
      final Map<String, dynamic> data = cattle.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();

      await firestore
          .collection('farms')
          .doc(farmId)
          .collection('cattle')
          .doc(cattle.id)
          .set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error uploading cattle ${cattle.id}: $e');
      return false;
    }
  }

  Future<bool> uploadMilkRecord(String farmId, MilkRecord record) async {
    final FirebaseFirestore? firestore = _firestore;
    if (firestore == null) return false;

    try {
      final Map<String, dynamic> data = record.toMap();
      data['updatedAt'] = FieldValue.serverTimestamp();

      await firestore
          .collection('farms')
          .doc(farmId)
          .collection('milk_records')
          .doc(record.id)
          .set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error uploading milk record ${record.id}: $e');
      return false;
    }
  }

  Future<bool> deleteRemoteEntity(String farmId, String entityType, String entityId) async {
    final FirebaseFirestore? firestore = _firestore;
    if (firestore == null) return false;

    try {
      final String collectionName = entityType == 'cattle' ? 'cattle' : 'milk_records';
      await firestore
          .collection('farms')
          .doc(farmId)
          .collection(collectionName)
          .doc(entityId)
          .delete();
      return true;
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error deleting remote entity $entityType/$entityId: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Entity Downloads
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchRemoteCattle(String farmId) async {
    final FirebaseFirestore? firestore = _firestore;
    if (firestore == null) return <Map<String, dynamic>>[];

    try {
      final QuerySnapshot<Map<String, dynamic>> query =
          await firestore.collection('farms').doc(farmId).collection('cattle').get();
      return query.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error fetching remote cattle: $e');
      return <Map<String, dynamic>>[];
    }
  }

  Future<List<Map<String, dynamic>>> fetchRemoteMilkRecords(String farmId) async {
    final FirebaseFirestore? firestore = _firestore;
    if (firestore == null) return <Map<String, dynamic>>[];

    try {
      final QuerySnapshot<Map<String, dynamic>> query =
          await firestore.collection('farms').doc(farmId).collection('milk_records').get();
      return query.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error fetching remote milk records: $e');
      return <Map<String, dynamic>>[];
    }
  }

  // ---------------------------------------------------------------------------
  // Image Storage Management
  // ---------------------------------------------------------------------------

  Future<String?> uploadImageFile(String farmId, String fileName, File file) async {
    final FirebaseStorage? storage = _storage;
    if (storage == null) return null;

    try {
      final Reference ref = storage.ref().child('farms/$farmId/images/$fileName');
      final UploadTask task = ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final TaskSnapshot snapshot = await task;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error uploading image $fileName: $e');
      return null;
    }
  }

  Future<bool> downloadImageFile(String farmId, String fileName, File destination) async {
    final FirebaseStorage? storage = _storage;
    if (storage == null) return false;

    try {
      final Reference ref = storage.ref().child('farms/$farmId/images/$fileName');
      await ref.writeToFile(destination);
      return true;
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] Error downloading image $fileName: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Phone Authentication (SMS OTP)
  // ---------------------------------------------------------------------------

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) async {
    final FirebaseAuth? auth = _auth;
    if (auth == null) {
      onError('Authentication service is not available.');
      return;
    }

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Phone verification failed.');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<bool> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final FirebaseAuth? auth = _auth;
    if (auth == null) return false;

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      debugPrint('[FirebaseSyncBackend] OTP verification error: $e');
      return false;
    }
  }
}
