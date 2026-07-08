import 'package:fitness_app/router/tab_module.dart';
import 'package:flutter/material.dart';

mixin DLTextMixin {
  String text(String key, String fallback);

  String get appTitle => text('app_title', 'DL');
  String get loginTitle => text('login_title', 'Login');
  String get loginPageTitle => text('login_page_title', 'Login Page');
  String get signInButton => text('sign_in_button', 'Sign In');
  String get pageNotFoundTitle =>
      text('page_not_found_title', 'Page Not Found');
  String get unknownRoute => text('unknown_route', 'Unknown route');
  String get homePageTitle => text('home_page_title', 'Home');
  String get loadingExercises =>
      text('loading_exercises', 'Loading exercises...');
  String get exercisesLoadError =>
      text('exercises_load_error', 'Failed to load exercises');
  String get exercisesEmpty =>
      text('exercises_empty', 'No exercises available');
  String get instructionLabel => text('instruction_label', 'Instruction');
  String get stepsLabel => text('steps_label', 'Steps');
  String get minePageTitle => text('mine_page_title', 'Mine Page');
  String get mineTabTitle => text('mine_tab_title', 'Mine');
  String get currentThemeLight =>
      text('current_theme_light', 'Current Theme: Light');
  String get currentThemeDark =>
      text('current_theme_dark', 'Current Theme: Dark');
  String get switchThemeToLight =>
      text('switch_theme_to_light', 'Switch to Light Mode');
  String get switchThemeToDark =>
      text('switch_theme_to_dark', 'Switch to Dark Mode');
  String get currentLocale =>
      text('current_locale', 'Current Language: English');
  String get switchLocale => text('switch_locale', '切换到中文');

  String tabTitle(TabModule tab) {
    return switch (tab) {
      TabModule.home => homePageTitle,
      TabModule.mine => mineTabTitle,
    };
  }

  String currentThemeLabel(ThemeMode mode) {
    return mode == ThemeMode.dark ? currentThemeDark : currentThemeLight;
  }

  String switchThemeLabel(ThemeMode mode) {
    return mode == ThemeMode.dark ? switchThemeToLight : switchThemeToDark;
  }
}
