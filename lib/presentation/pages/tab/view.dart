import 'package:fitness_app/core/settings/app_settings.dart';
import 'package:fitness_app/core/settings/app_text.dart';
import 'package:fitness_app/presentation/pages/home/view.dart';
import 'package:fitness_app/presentation/pages/mine/view.dart';
import 'package:fitness_app/presentation/pages/tab/notifier.dart';
import 'package:fitness_app/presentation/pages/tab/state.dart';
import 'package:fitness_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabBarPage extends ConsumerStatefulWidget {
  const TabBarPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends ConsumerState<TabBarPage> {
  final pages = const <Widget>[HomePage(), MinePage()];

  @override
  void initState() {
    super.initState();
    ref
        .read(tabBarNotifierProvider.notifier)
        .syncFromRouteIndex(widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant TabBarPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIndex != widget.initialIndex) {
      ref
          .read(tabBarNotifierProvider.notifier)
          .syncFromRouteIndex(widget.initialIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabState = ref.watch(tabBarNotifierProvider);
    final locale = ref.watch(appLocaleProvider);
    final activeTab = TabModule.values[tabState.currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(AppText.tabTitle(locale, activeTab))),
      body: IndexedStack(index: tabState.currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabState.currentIndex,
        onTap: (index) {
          if (index == tabState.currentIndex) {
            return;
          }

          final tabNotifier = ref.read(tabBarNotifierProvider.notifier);
          final navigation = ref.read(navigationProvider);

          tabNotifier.selectTabAndSyncRoute(index, navigation);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppText.tabLabel(locale, TabModule.home),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppText.tabLabel(locale, TabModule.mine),
          ),
        ],
      ),
    );
  }
}
