import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/core/settings/app_locale_provider.dart';
import 'package:fitness_app/core/settings/app_text.dart';

final appTextProvider = NotifierProvider<AppTextNotifier, DLAppText>(
  AppTextNotifier.new,
);

class AppTextNotifier extends Notifier<DLAppText> {
  @override
  DLAppText build() {
    // 监听 locale 变化
    ref.listen(appLocaleProvider, (_, locale) {
      load(locale);
    });
    // 初始加载
    final locale = ref.watch(appLocaleProvider);
    return _loadSync(locale);
  }

  DLAppText _loadSync(Locale locale) {
    // 同步返回空实例，实际内容会在首次访问时通过 load() 更新
    // 对于初次渲染，使用同步空实例，后续会自动更新
    return DLAppText.empty();
  }

  Future<void> load(Locale locale) async {
    state = await DLAppText.load(locale);
  }
}
