import 'package:fitness_app/core/settings/app_locale_provider.dart';
import 'package:fitness_app/core/settings/app_text.dart';
import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/core/settings/app_theme_provider.dart';
import 'package:fitness_app/router/app_router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DLApp extends ConsumerWidget {
  const DLApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    final appText = ref.watch(appTextProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => appText.appTitle,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: DLAppLocal.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DLAppText.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }
}
