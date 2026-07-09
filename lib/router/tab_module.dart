enum TabModule {
  home('home', 'Home'),
  exerciseAll('exercise_all', 'All'),
  mine('mine', 'Mine');

  const TabModule(this.queryValue, this.tabName);

  final String queryValue;
  final String tabName;

  static TabModule fromQuery(String? value) {
    return switch (value) {
      'mine' => TabModule.mine,
      'exercise_all' => TabModule.exerciseAll,
      _ => TabModule.home,
    };
  }
}
