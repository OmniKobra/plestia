import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'locales/app_language.dart';
import 'providers/theme_provider.dart';

enum Sortation { top, newest, oldest }

class General {
  static void changeSortation(Sortation oldSort, Sortation newSort) =>
      oldSort = newSort;

  // LOCALE IS VARIABLE SERVERLANGCODE
  static String timeStamp(
      DateTime postedDate, String locale, BuildContext context) {
    final String datewithYear = locale == 'ar'
        ? DateFormat('MMMM d - yyyy', locale).format(postedDate)
        : DateFormat('MMMM d, yyyy', locale).format(postedDate);
    return datewithYear;
  }

  static String optimisedNumbers(num value) {
    if (value < 1000) {
      return value.toString();
    } else if (value >= 1000 && value < 1000000) {
      num dividedVal = value / 1000;
      return '${dividedVal.toStringAsFixed(0)}K';
    } else if (value >= 1000000 && value < 1000000000) {
      num dividedVal = value / 1000000;
      return '${dividedVal.toStringAsFixed(0)}M';
    } else if (value >= 1000000000) {
      num dividedVal = value / 1000000000;
      return '${dividedVal.toStringAsFixed(0)}B';
    }
    return 'null';
  }

  static AppLanguage language(BuildContext context) =>
      Provider.of<ThemeModel>(context).appLanguage;
}
