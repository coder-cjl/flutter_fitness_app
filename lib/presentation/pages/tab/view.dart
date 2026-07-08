import 'package:fitness_app/presentation/pages/home/view.dart';
import 'package:fitness_app/presentation/pages/mine/view.dart';
import 'package:fitness_app/presentation/pages/tab/logic.dart';
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
  @override
  void initState() {
    super.initState();
    ref
        .read(tabBarLogicProvider.notifier)
        .syncFromRouteIndex(widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant TabBarPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIndex != widget.initialIndex) {
      ref
          .read(tabBarLogicProvider.notifier)
          .syncFromRouteIndex(widget.initialIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabState = ref.watch(tabBarLogicProvider);
    final tabLogic = ref.read(tabBarLogicProvider.notifier);
    final navigation = ref.read(navigationProvider);
    const pages = <Widget>[HomePage(), MinePage()];

    return Scaffold(
      appBar: AppBar(title: Text(tabState.title)),
      body: IndexedStack(index: tabState.currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabState.currentIndex,
        onTap: (index) {
          if (index == tabState.currentIndex) {
            return;
          }

          tabLogic.selectTabAndSyncRoute(index, navigation);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mine'),
        ],
      ),
    );
  }
}
