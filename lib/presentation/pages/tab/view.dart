import 'package:fitness_app/core/settings/app_settings.dart';
import 'package:fitness_app/core/settings/app_text.dart';
import 'package:fitness_app/presentation/pages/home/view.dart';
import 'package:fitness_app/presentation/pages/mine/view.dart';
import 'package:fitness_app/presentation/pages/tab/tab_module.dart';
import 'package:fitness_app/router/app_router.dart';
import 'package:fitness_app/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabBarPage extends ConsumerWidget {
  const TabBarPage({super.key, this.activeTab = TabModule.home});

  final TabModule activeTab;

  static const pages = <Widget>[HomePage(), MinePage()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppText.tabTitle(locale, activeTab))),
      body: IndexedStack(index: activeTab.index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeTab.index,
        onTap: (index) {
          final nextTab = TabModule.values[index];
          if (nextTab == activeTab) {
            return;
          }

          final navigation = ref.read(navigationProvider);
          navigation.goNamed(
            AppRoute.tabName,
            queryParams: {'tab': nextTab.queryValue},
          );
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
