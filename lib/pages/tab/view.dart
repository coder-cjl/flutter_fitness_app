import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/pages/exercise_all/view.dart';
import 'package:fitness_app/pages/home/view.dart';
import 'package:fitness_app/pages/mine/view.dart';
import 'package:fitness_app/pages/workout_plan/view.dart';
import 'package:fitness_app/router/app_router_provider.dart';
import 'package:fitness_app/router/app_route_url.dart';
import 'package:fitness_app/router/tab_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabBarPage extends ConsumerWidget {
  const TabBarPage({super.key, this.activeTab = TabModule.home});

  final TabModule activeTab;

  static const pages = <Widget>[
    HomePage(),
    WorkoutPlanPage(),
    ExerciseAllPage(),
    MinePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appText = ref.watch(appTextProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: IndexedStack(index: activeTab.index, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: activeTab.index,
          onDestinationSelected: (index) {
            final nextTab = TabModule.values[index];
            if (nextTab == activeTab) {
              return;
            }

            ref
                .read(navigationProvider)
                .goNamed(
                  AppRoute.tabName,
                  queryParams: {'tab': nextTab.queryValue},
                );
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home),
              label: appText.tabTitle(TabModule.home),
            ),
            NavigationDestination(
              icon: const Icon(Icons.edit_note),
              label: appText.tabTitle(TabModule.workoutPlan),
            ),
            NavigationDestination(
              icon: const Icon(Icons.fitness_center),
              label: appText.tabTitle(TabModule.exerciseAll),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person),
              label: appText.tabTitle(TabModule.mine),
            ),
          ],
        ),
      ),
    );
  }
}
