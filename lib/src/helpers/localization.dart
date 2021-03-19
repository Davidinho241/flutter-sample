import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// Helper method to keep the code in the widgets concise
  /// Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, dynamic> _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/json/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value);
    });

    return true;
  }

  String translate(String key) {
    var nestedMap = _getNestedValue(key);
    return nestedMap.toString();
  }

  dynamic _getNestedValue(String keyPath) {
    Map keyMap = keyPath.split('.').asMap();
    var nestedMap;
    keyMap.forEach((index, key) {
      if (index == 0) {
        nestedMap = _localizedStrings[key];
      } else {
        nestedMap = nestedMap[key];
      }
    });
    return nestedMap;
  }

}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  // add all languages code here
  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  // load all localization files
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
