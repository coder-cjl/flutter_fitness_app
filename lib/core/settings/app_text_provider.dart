import 'package:fitness_app/core/settings/app_locale_provider.dart';
import 'package:fitness_app/core/settings/app_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 应用文案的异步加载状态。
final appTextAsyncProvider = FutureProvider<DLAppText>((ref) {
  final locale = ref.watch(appLocaleProvider);
  return DLAppText.load(locale);
});

/// 便捷的同步文案入口。
///
/// UI 可以继续直接读取文案；首次加载或切换语言的短暂 loading 阶段使用
/// DLAppText 自带的 fallback 文案，避免在每个页面重复处理 loading。
final appTextProvider = Provider<DLAppText>((ref) {
  final textAsync = ref.watch(appTextAsyncProvider);
  return textAsync.value ?? DLAppText.empty();
});
