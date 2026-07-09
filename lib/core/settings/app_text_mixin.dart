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
  String get exerciseAllPageTitle =>
      text('exercise_all_page_title', 'Exercise All');
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

  // Detail page labels
  String get bodyPartLabel => text('body_part_label', 'Body Part');
  String get equipmentLabel => text('equipment_label', 'Equipment');
  String get targetLabel => text('target_label', 'Target');
  String get secondaryMusclesLabel =>
      text('secondary_muscles_label', 'Secondary Muscles');

  // Workout plan labels
  String get workoutPlanTitle => text('workout_plan_title', 'Workout Plan');
  String get addExerciseLabel => text('add_exercise_label', 'Add Exercise');
  String get clearPlanLabel => text('clear_plan_label', 'Clear Plan');
  String get workoutPlanEmpty => text('workout_plan_empty', 'No exercises yet');
  String get workoutPlanEmptyHint =>
      text('workout_plan_empty_hint', 'Tap + to add exercises');
  String get workoutItemsLabel =>
      text('workout_items_label', 'Exercises');
  String get cyclesLabel => text('cycles_label', 'Cycles');
  String get setsLabel => text('sets_label', 'Sets');
  String get repsLabel => text('reps_label', 'Reps');
  String get selectExerciseLabel =>
      text('select_exercise_label', 'Select Exercise');
  String get completeWorkoutLabel =>
      text('complete_workout_label', 'Complete Workout');
  String get workoutCompletedMessage =>
      text('workout_completed_message', 'Workout completed!');
  String get workoutHistoryTitle =>
      text('workout_history_title', 'Workout History');
  String get workoutInProgress =>
      text('workout_in_progress', 'In Progress');
  String get workoutCompleted =>
      text('workout_completed', 'Completed');
  String get workoutHistoryEmpty =>
      text('workout_history_empty', 'No workout history');
  String get workoutHistoryEmptyHint =>
      text('workout_history_empty_hint', 'Complete a workout to see it here');
  String get addWorkoutLabel => text('add_workout_label', 'New Workout');
  String get createWorkoutLabel =>
      text('create_workout_label', 'Create Workout');
  String get selectWorkoutHint =>
      text('select_workout_hint', 'Select a workout to edit');
  String get noExercisesHint =>
      text('no_exercises_hint', 'No exercises added yet');

  String tabTitle(TabModule tab) {
    return switch (tab) {
      TabModule.home => homePageTitle,
      TabModule.workoutPlan => workoutPlanTitle,
      TabModule.exerciseAll => exerciseAllPageTitle,
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
