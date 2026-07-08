import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DLAppLocal {
  const DLAppLocal._();

  static const Locale zhCN = Locale('zh', 'CN');
  static const Locale enUS = Locale('en', 'US');
  static const Locale esES = Locale('es', 'ES');

  static const List<Locale> supportedLocales = <Locale>[zhCN, enUS, esES];
}

class AppLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => DLAppLocal.zhCN;

  void setLocale(Locale locale) {
    state = locale;
  }
}

final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale>(
  AppLocaleNotifier.new,
);
