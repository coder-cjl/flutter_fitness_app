import 'package:fitness_app/core/settings/app_settings.dart';
import 'package:fitness_app/presentation/pages/tab/state.dart';
import 'package:flutter/material.dart';

class AppText {
  const AppText._();

  static bool isZh(Locale locale) {
    return locale.languageCode == AppSettings.zhCN.languageCode;
  }

  static String homePageTitle(Locale locale) {
    return isZh(locale) ? '首页' : 'Home Page';
  }

  static String minePageTitle(Locale locale) {
    return isZh(locale) ? '我的页面' : 'Mine Page';
  }

  static String tabTitle(Locale locale, TabModule tab) {
    final zh = isZh(locale);
    return switch (tab) {
      TabModule.home => zh ? '首页' : 'Home',
      TabModule.mine => zh ? '我的' : 'Mine',
    };
  }

  static String tabLabel(Locale locale, TabModule tab) {
    return tabTitle(locale, tab);
  }

  static String currentThemeLabel(Locale locale, ThemeMode mode) {
    final zh = isZh(locale);
    if (mode == ThemeMode.dark) {
      return zh ? '当前主题：深色' : 'Current Theme: Dark';
    }
    return zh ? '当前主题：浅色' : 'Current Theme: Light';
  }

  static String switchThemeLabel(Locale locale, ThemeMode mode) {
    final zh = isZh(locale);
    if (mode == ThemeMode.dark) {
      return zh ? '切换到浅色模式' : 'Switch to Light Mode';
    }
    return zh ? '切换到深色模式' : 'Switch to Dark Mode';
  }

  static String currentLocaleLabel(Locale locale) {
    return isZh(locale) ? '当前语言：中文' : 'Current Language: English';
  }

  static String switchLocaleLabel(Locale locale) {
    return isZh(locale) ? 'Switch to English' : '切换到中文';
  }
}
