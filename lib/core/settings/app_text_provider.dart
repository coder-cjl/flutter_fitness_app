import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/core/settings/app_locale_provider.dart';
import 'package:fitness_app/core/settings/app_text.dart';

final appTextProvider = NotifierProvider<AppTextNotifier, DLAppText>(
  AppTextNotifier.new,
);

class AppTextNotifier extends Notifier<DLAppText> {
  // 缓存已加载的文本
  static final Map<String, DLAppText> _cache = {};

  @override
  DLAppText build() {
    final locale = ref.watch(appLocaleProvider);
    final cacheKey = locale.languageCode;

    // 监听 locale 变化，加载新语言文本
    ref.listen(appLocaleProvider, (_, newLocale) {
      final key = newLocale.languageCode;
      if (_cache.containsKey(key)) {
        // 使用缓存
        Future.microtask(() => load(key));
      }
    });

    // 如果有缓存直接返回，否则触发加载
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // 触发异步加载
    Future.microtask(() => load(cacheKey));

    // 返回空实例，首次加载完成后会更新
    return DLAppText.empty();
  }

  Future<void> load(String cacheKey) async {
    if (_cache.containsKey(cacheKey)) {
      state = _cache[cacheKey]!;
      return;
    }

    final locale = switch (cacheKey) {
      'zh' => DLAppLocal.zhCN,
      'es' => DLAppLocal.esES,
      _ => DLAppLocal.enUS,
    };

    final text = await DLAppText.load(locale);
    _cache[cacheKey] = text;
    state = text;
  }
}
