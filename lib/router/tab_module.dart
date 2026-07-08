enum TabModule {
  home('home'),
  exerciseAll('exercise_all'),
  mine('mine');

  const TabModule(this.queryValue);

  final String queryValue;

  static TabModule fromQuery(String? value) {
    return switch (value) {
      'mine' => TabModule.mine,
      'exercise_all' => TabModule.exerciseAll,
      _ => TabModule.home,
    };
  }
}
