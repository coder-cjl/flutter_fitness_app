enum TabModule {
  home('home', 'Home'),
  workoutPlan('workout_plan', 'Plan'),
  exerciseAll('exercise_all', 'All'),
  mine('mine', 'Mine');

  const TabModule(this.queryValue, this.tabName);

  final String queryValue;
  final String tabName;

  static TabModule fromQuery(String? value) {
    return switch (value) {
      'mine' => TabModule.mine,
      'exercise_all' => TabModule.exerciseAll,
      'workout_plan' => TabModule.workoutPlan,
      _ => TabModule.home,
    };
  }
}
