import 'package:fitness_app/core/settings/app_settings.dart';
import 'package:fitness_app/core/settings/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MinePage extends ConsumerWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    final pageTitle = AppText.minePageTitle(locale);
    final currentThemeLabel = AppText.currentThemeLabel(locale, themeMode);
    final switchThemeLabel = AppText.switchThemeLabel(locale, themeMode);
    final currentLocaleLabel = AppText.currentLocaleLabel(locale);
    final switchLocaleLabel = AppText.switchLocaleLabel(locale);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(pageTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(currentThemeLabel),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.read(appThemeModeProvider.notifier).toggle(),
              child: Text(switchThemeLabel),
            ),
            const SizedBox(height: 16),
            Text(currentLocaleLabel),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.read(appLocaleProvider.notifier).toggle(),
              child: Text(switchLocaleLabel),
            ),
          ],
        ),
      ),
    );
  }
}
