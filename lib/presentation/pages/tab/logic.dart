import 'package:fitness_app/presentation/pages/tab/state.dart';
import 'package:fitness_app/router/app_route.dart';
import 'package:fitness_app/router/navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabBarLogicProvider =
    NotifierProvider.family<TabBarLogic, TabBarState, int>(TabBarLogic.new);

class TabBarLogic extends Notifier<TabBarState> {
  TabBarLogic(this.initialIndex);

  final int initialIndex;

  @override
  TabBarState build() {
    return TabBarState(activeTab: TabModule.values[_safeIndex(initialIndex)]);
  }

  void selectTab(int index) {
    final safeIndex = _safeIndex(index);
    final nextTab = TabModule.values[safeIndex];

    if (nextTab == state.activeTab) {
      return;
    }

    state = state.copyWith(activeTab: nextTab);
  }

  void selectTabAndSyncRoute(int index, DLNavigation navigation) {
    final previousTab = state.activeTab;
    selectTab(index);

    if (state.activeTab != previousTab) {
      navigation.goNamed(
        AppRoute.tabName,
        queryParams: {'tab': state.activeTab.queryValue},
      );
    }
  }

  static int _safeIndex(int index) {
    if (index < 0) {
      return 0;
    }

    final maxIndex = TabModule.values.length - 1;
    if (index > maxIndex) {
      return maxIndex;
    }

    return index;
  }
}
