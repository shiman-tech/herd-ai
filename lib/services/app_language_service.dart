import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLanguageService extends ChangeNotifier {
  AppLanguageService._();
  
  static final AppLanguageService instance = AppLanguageService._();
  
  static const String _localeKey = 'app_locale';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final String? cachedLanguageCode = await _secureStorage.read(key: _localeKey);
    if (cachedLanguageCode != null) {
      _locale = Locale(cachedLanguageCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    await _secureStorage.write(key: _localeKey, value: languageCode);
  }
}
