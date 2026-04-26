import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AppAuthService {
  static const String _pinKey = 'app_pin';

  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;

  AppAuthService({
    FlutterSecureStorage? secureStorage,
    LocalAuthentication? localAuth,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _localAuth = localAuth ?? LocalAuthentication();

  String _hashPin(String pin) {
    final List<int> bytes = utf8.encode(pin);
    return sha256.convert(bytes).toString();
  }

  Future<void> savePin(String pin) async {
    await _secureStorage.write(key: _pinKey, value: _hashPin(pin));
  }

  Future<String?> getPin() async {
    return _secureStorage.read(key: _pinKey);
  }

  Future<bool> hasPin() async {
    final String? saved = await getPin();
    return saved != null && saved.isNotEmpty;
  }

  Future<bool> verifyPin(String inputPin) async {
    final String? saved = await getPin();
    if (saved == null || saved.isEmpty) {
      return false;
    }
    return saved == _hashPin(inputPin);
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool supported = await _localAuth.isDeviceSupported();
      final bool canCheck = await _localAuth.canCheckBiometrics;
      if (!supported || !canCheck) {
        return false;
      }

      final List<BiometricType> available = await _localAuth
          .getAvailableBiometrics();
      if (available.isEmpty) {
        return false;
      }

      return _localAuth.authenticate(
        localizedReason: 'Unlock your app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }

  Future<bool> unlockFlow() async {
    final bool pinExists = await hasPin();
    if (!pinExists) {
      return false;
    }
    return authenticateWithBiometrics();
  }
}
