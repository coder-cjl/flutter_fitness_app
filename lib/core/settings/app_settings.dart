import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  const AppSettings._();

  static const Locale zhCN = Locale('zh', 'CN');
  static const Locale enUS = Locale('en', 'US');

  static const List<Locale> supportedLocales = <Locale>[zhCN, enUS];
}

final appThemeModeProvider = NotifierProvider<AppThemeModeNotifier, ThemeMode>(
  AppThemeModeNotifier.new,
);

class AppThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale>(
  AppLocaleNotifier.new,
);

class AppLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => AppSettings.zhCN;

  void toggle() {
    state = state.languageCode == AppSettings.zhCN.languageCode
        ? AppSettings.enUS
        : AppSettings.zhCN;
  }
}
