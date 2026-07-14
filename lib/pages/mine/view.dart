import 'package:fitness_app/core/settings/app_locale_provider.dart';
import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/core/settings/app_theme_provider.dart';
import 'package:fitness_app/pages/login/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MinePage extends ConsumerWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final currentLocale = ref.watch(appLocaleProvider);
    final appText = ref.watch(appTextProvider);
    final pageTitle = appText.minePageTitle;
    final currentThemeLabel = appText.currentThemeLabel(themeMode);
    final switchThemeLabel = appText.switchThemeLabel(themeMode);

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(currentThemeLabel),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.read(appThemeModeProvider.notifier).toggle(),
                child: Text(switchThemeLabel),
              ),
              const SizedBox(height: 8),
              Text("退出登录"),
              ElevatedButton(
                onPressed: () {
                  ref.read(userProvider.notifier).logout();
                },
                child: Text("退出登录"),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Language / 语言 / Idioma',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _LanguageButton(
                locale: DLAppLocal.zhCN,
                label: '中文',
                isSelected: currentLocale.languageCode == 'zh',
                onTap: () => ref
                    .read(appLocaleProvider.notifier)
                    .setLocale(DLAppLocal.zhCN),
              ),
              const SizedBox(height: 8),
              _LanguageButton(
                locale: DLAppLocal.enUS,
                label: 'English',
                isSelected: currentLocale.languageCode == 'en',
                onTap: () => ref
                    .read(appLocaleProvider.notifier)
                    .setLocale(DLAppLocal.enUS),
              ),
              const SizedBox(height: 8),
              _LanguageButton(
                locale: DLAppLocal.esES,
                label: 'Español',
                isSelected: currentLocale.languageCode == 'es',
                onTap: () => ref
                    .read(appLocaleProvider.notifier)
                    .setLocale(DLAppLocal.esES),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final Locale locale;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.locale,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
        ),
        child: Text(label),
      ),
    );
  }
}
