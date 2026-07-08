import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/pages/exercise_all/view.dart';
import 'package:fitness_app/pages/home/view.dart';
import 'package:fitness_app/pages/mine/view.dart';
import 'package:fitness_app/router/app_router_provider.dart';
import 'package:fitness_app/router/app_route_url.dart';
import 'package:fitness_app/router/tab_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabBarPage extends ConsumerWidget {
  const TabBarPage({super.key, this.activeTab = TabModule.home});

  final TabModule activeTab;

  static const pages = <Widget>[HomePage(), ExerciseAllPage(), MinePage()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appText = ref.watch(appTextProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(title: Text(appText.tabTitle(activeTab))),
        body: IndexedStack(index: activeTab.index, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: activeTab.index,
          onTap: (index) {
            final nextTab = TabModule.values[index];
            if (nextTab == activeTab) {
              return;
            }

            ref
                .read(navigationProvider)
                .goNamed(AppRoute.tabName, queryParams: {'tab': nextTab.name});
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: appText.tabTitle(TabModule.home),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center),
              label: appText.tabTitle(TabModule.exerciseAll),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: appText.tabTitle(TabModule.mine),
            ),
          ],
        ),
      ),
    );
  }
}
