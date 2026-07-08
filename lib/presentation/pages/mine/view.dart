import 'package:fitness_app/core/settings/app_local.dart';
import 'package:fitness_app/core/settings/app_text.dart';
import 'package:fitness_app/core/settings/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MinePage extends ConsumerWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    final appText = DLAppText.of(context);
    final pageTitle = appText.minePageTitle;
    final currentThemeLabel = appText.currentThemeLabel(themeMode);
    final switchThemeLabel = appText.switchThemeLabel(themeMode);
    final currentLocaleLabel = appText.currentLocale;
    final switchLocaleLabel = appText.switchLocale;

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
              onPressed: () {
                ref.read(appLocaleProvider.notifier).setLocale(DLAppLocal.esES);
              },
              child: Text(switchLocaleLabel),
            ),
          ],
        ),
      ),
    );
  }
}
