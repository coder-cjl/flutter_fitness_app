import 'package:flutter/material.dart';

class LocalizedText {
  const LocalizedText(this.values);

  final Map<String, String> values;

  factory LocalizedText.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const LocalizedText(<String, String>{});
    }

    return LocalizedText(
      json.map((key, value) => MapEntry(key.toLowerCase(), '$value')),
    );
  }

  String resolve(Locale locale, {String fallbackLanguage = 'en'}) {
    final keys = _candidateLanguageKeys(locale, fallbackLanguage);

    for (final key in keys) {
      final value = values[key];
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }

    for (final value in values.values) {
      if (value.trim().isNotEmpty) {
        return value;
      }
    }

    return '';
  }
}

class LocalizedTextList {
  const LocalizedTextList(this.values);

  final Map<String, List<String>> values;

  factory LocalizedTextList.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const LocalizedTextList(<String, List<String>>{});
    }

    return LocalizedTextList(
      json.map((key, value) {
        final rawList = value is List ? value : const <dynamic>[];
        final parsed = rawList.map((e) => '$e').toList(growable: false);
        return MapEntry(key.toLowerCase(), parsed);
      }),
    );
  }

  List<String> resolve(Locale locale, {String fallbackLanguage = 'en'}) {
    final keys = _candidateLanguageKeys(locale, fallbackLanguage);

    for (final key in keys) {
      final value = values[key];
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    for (final value in values.values) {
      if (value.isNotEmpty) {
        return value;
      }
    }

    return const <String>[];
  }
}

List<String> _candidateLanguageKeys(Locale locale, String fallbackLanguage) {
  final languageCode = locale.languageCode.toLowerCase();
  final countryCode = locale.countryCode?.toLowerCase();

  final keys = <String>[
    if (countryCode != null && countryCode.isNotEmpty)
      '${languageCode}_$countryCode',
    if (countryCode != null && countryCode.isNotEmpty)
      '${languageCode.toLowerCase()}-${countryCode.toLowerCase()}',
    languageCode,
    fallbackLanguage.toLowerCase(),
    'zh',
    'en',
  ];

  return keys.toSet().toList(growable: false);
}
