// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const LANG = 'lang';

  setLanguage(String newCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(LANG, newCode);
  }

  String giveLanguageFromCode(String code) {
    // all lang codes are here https://www.iana.org/assignments/language-subtag-registry
    switch (code) {
      case 'en':
        return 'en';
      case 'ar':
        return 'ar';
      case 'tr':
        return 'tr';
      case 'fr':
        return 'fr';
      default:
        return 'en';
    }
  }

  String determineStartingLanguage(BuildContext context) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final lang = locale.languageCode;
    return giveLanguageFromCode(lang);
  }

  Future<List<dynamic>> getTheme(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var appLang =
        sharedPreferences.getString(LANG) ?? determineStartingLanguage(context);
    return [appLang];
  }
}
