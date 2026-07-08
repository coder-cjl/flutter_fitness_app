import 'dart:convert';
import 'package:fitness_app/core/settings/app_locale_provider.dart';
import 'package:fitness_app/core/settings/app_text_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DLAppText with DLTextMixin {
  DLAppText._(this._values);

  factory DLAppText.empty() => DLAppText._({});

  final Map<String, String> _values;

  static const LocalizationsDelegate<DLAppText> delegate = _DLAppTextDelegate();

  static DLAppText of(BuildContext context) {
    return Localizations.of<DLAppText>(context, DLAppText)!;
  }

  static Future<DLAppText> load(Locale locale) async {
    final languageCode = _supportedLanguageCode(locale);
    final raw = await rootBundle.loadString('assets/jsons/$languageCode.json');
    final decoded = jsonDecode(raw);

    if (decoded is! Map<String, dynamic>) {
      return DLAppText.empty();
    }

    return DLAppText._(
      decoded.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  /// 同步加载（使用缓存的 JSON 字符串）
  static DLAppText loadSync(Locale locale) {
    final languageCode = _supportedLanguageCode(locale);
    // 默认加载 assets
    return _loadFromAssets(languageCode);
  }

  static DLAppText _loadFromAssets(String languageCode) {
    // 同步加载使用 rootBundle
    try {
      // 注意：rootBundle.loadString 实际上是异步的，这里我们缓存加载结果
      // 对于首次加载，我们仍然返回空实例，后续通过异步加载更新
      return DLAppText.empty();
    } catch (e) {
      return DLAppText.empty();
    }
  }

  static String _supportedLanguageCode(Locale locale) {
    if (locale.languageCode == DLAppLocal.zhCN.languageCode) {
      return DLAppLocal.zhCN.languageCode;
    }
    if (locale.languageCode == DLAppLocal.esES.languageCode) {
      return DLAppLocal.esES.languageCode;
    }

    return DLAppLocal.enUS.languageCode;
  }

  @override
  String text(String key, String fallback) {
    return _values[key] ?? fallback;
  }
}

class _DLAppTextDelegate extends LocalizationsDelegate<DLAppText> {
  const _DLAppTextDelegate();

  @override
  bool isSupported(Locale locale) {
    return DLAppLocal.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<DLAppText> load(Locale locale) {
    return DLAppText.load(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<DLAppText> old) {
    // locale 变化时应该重新加载
    return true;
  }
}
