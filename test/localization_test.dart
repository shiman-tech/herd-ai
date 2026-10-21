import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herd_ai/l10n/app_localizations.dart';

void main() {
  test('Malayalam (ml) localization loads and provides localized strings', () async {
    final localizations = await AppLocalizations.delegate.load(const Locale('ml'));
    expect(localizations.appName, 'ഹെർഡ് എഐ (Herd AI)');
    expect(localizations.appSubtitle, 'നിങ്ങളുടെ കന്നുകാലി നോട്ട്ബുക്ക്');
    expect(localizations.identifyTab, 'തിരിച്ചറിയുക');
    expect(localizations.cattleTab, 'എന്റെ കന്നുകാലികൾ');
    expect(localizations.milkYieldTab, 'പാൽ അളവ്');
    expect(localizations.settings, 'ക്രമീകരണങ്ങൾ');
    expect(localizations.language, 'ഭാഷ (Language)');
    expect(localizations.female, 'പെൺ');
    expect(localizations.male, 'ആൺ');
    expect(localizations.calf, 'കിടാവ്');
    expect(localizations.cow, 'പശു');
    expect(localizations.showingCattleCount(5, 10), '10-ൽ 5 കന്നുകാലികളെ കാണിക്കുന്നു');
    expect(localizations.cowsMilked(4), '4 പശുക്കളെ കറന്നു');
  });
}
