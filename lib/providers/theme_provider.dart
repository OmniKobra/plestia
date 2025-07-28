import 'package:flutter/material.dart';

import '../locales/app_language.dart';
import '../locales/ar_applanguage.dart';
import '../locales/en_applanguage.dart';
import '../locales/fr_applanguage.dart';
import '../locales/tr_applanguage.dart';
import '../models/theme_model.dart';

class ThemeModel extends ChangeNotifier {
  final ThemePreferences _preferences = ThemePreferences();
  TextDirection _textDirection = TextDirection.ltr;
  AppLanguage _appLanguage = EN_Language();
  String _langCode = 'en';
  String _serverLangCode = 'en';
  TextDirection get textDirection => _textDirection;
  String get langCode => _langCode;
  String get serverLangCode => _serverLangCode;
  ThemeModel(BuildContext context) {
    getPreferences(context);
  }
  AppLanguage get appLanguage => _appLanguage;
  void handleLangCodeToClass(String paramlangCode) {
    switch (paramlangCode) {
      case 'en':
        _appLanguage = EN_Language();
        _serverLangCode = 'en';
        _langCode = 'en';
        _textDirection = TextDirection.ltr;
        break;
      case 'ar':
        _appLanguage = AR_Language();
        _serverLangCode = 'ar';
        _langCode = 'ar';
        _textDirection = TextDirection.rtl;
        break;
      case 'tr':
        _appLanguage = TR_Language();
        _serverLangCode = 'tr';
        _langCode = 'tr';
        _textDirection = TextDirection.ltr;
        break;
      case 'fr':
        _appLanguage = FR_Language();
        _serverLangCode = 'fr';
        _langCode = 'fr';
        _textDirection = TextDirection.ltr;
        break;
      default:
        _appLanguage = EN_Language();
        _serverLangCode = 'en';
        _langCode = 'en';
        _textDirection = TextDirection.ltr;
        break;
    }
  }

  void setLanguage(String newCode) {
    _preferences.setLanguage(newCode);
    handleLangCodeToClass(newCode);
    notifyListeners();
  }

  getPreferences(BuildContext context) async {
    List<dynamic> colors = await _preferences.getTheme(context);
    var thislangCode = colors[0];
    handleLangCodeToClass(thislangCode);
    notifyListeners();
  }
}
