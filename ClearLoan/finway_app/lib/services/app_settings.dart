import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static final ValueNotifier<String> language = ValueNotifier<String>('en'); // en/ru/ky
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
  static final ValueNotifier<String> userType = ValueNotifier<String>('individual'); // individual/legal

  static const _kLang = 'lang';
  static const _kTheme = 'theme';
  static const _kUserType = 'user_type';

  static Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    language.value = sp.getString(_kLang) ?? 'en';
    userType.value = sp.getString(_kUserType) ?? 'individual';
    final theme = sp.getString(_kTheme) ?? 'light';
    themeMode.value = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> setLanguage(String lang) async {
    language.value = lang;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLang, lang);
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kTheme, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  static Future<void> setUserType(String type) async {
    userType.value = type;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kUserType, type);
  }
}
