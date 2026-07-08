enum TabModule { home, mine }

extension TabModuleX on TabModule {
  String get title => switch (this) {
    TabModule.home => 'Home',
    TabModule.mine => 'Mine',
  };

  String get queryValue => switch (this) {
    TabModule.home => 'home',
    TabModule.mine => 'mine',
  };
}

class TabBarState {
  const TabBarState({required this.activeTab});

  final TabModule activeTab;

  int get currentIndex => activeTab.index;
  String get title => activeTab.title;
  String get queryValue => activeTab.queryValue;

  TabBarState copyWith({TabModule? activeTab}) {
    return TabBarState(activeTab: activeTab ?? this.activeTab);
  }
}
