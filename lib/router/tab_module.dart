enum TabModule {
  home('home'),
  mine('mine');

  const TabModule(this.queryValue);

  final String queryValue;

  static TabModule fromQuery(String? value) {
    return switch (value) {
      'mine' => TabModule.mine,
      _ => TabModule.home,
    };
  }
}
