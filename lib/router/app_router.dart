import 'package:fitness_app/presentation/pages/login/view.dart';
import 'package:fitness_app/presentation/pages/tab/view.dart';
import 'package:fitness_app/router/app_route.dart';
import 'package:fitness_app/router/auth_state.dart';
import 'package:fitness_app/router/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = ref.watch(rootNavigatorKeyProvider);
  final authRefreshListenable = ValueNotifier<int>(0);

  ref.listen<bool>(authStateProvider, (previous, next) {
    authRefreshListenable.value++;
  });

  ref.onDispose(authRefreshListenable.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    refreshListenable: authRefreshListenable,
    initialLocation: AppRoute.tabPath,
    routes: <RouteBase>[
      GoRoute(
        name: AppRoute.loginName,
        path: AppRoute.loginPath,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: AppRoute.tabName,
        path: AppRoute.tabPath,
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'];
          final initialIndex = switch (tab) {
            'mine' => 1,
            _ => 0,
          };

          return TabBarPage(initialIndex: initialIndex);
        },
      ),
      GoRoute(
        name: AppRoute.homeName,
        path: AppRoute.homePath,
        redirect: (context, state) => '${AppRoute.tabPath}?tab=home',
      ),
      GoRoute(
        name: AppRoute.mineName,
        path: AppRoute.minePath,
        redirect: (context, state) => '${AppRoute.tabPath}?tab=mine',
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = ref.read(authStateProvider);
      final isOnLogin = state.matchedLocation == AppRoute.loginPath;

      if (!isLoggedIn && !isOnLogin) {
        final from = Uri.encodeComponent(state.matchedLocation);
        return '${AppRoute.loginPath}?from=$from';
      }

      if (isLoggedIn && isOnLogin) {
        final from = state.uri.queryParameters['from'];

        if (from != null && from.isNotEmpty) {
          return Uri.decodeComponent(from);
        }

        return AppRoute.tabPath;
      }

      return null;
    },
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(child: Text(state.error?.toString() ?? 'Unknown route')),
      );
    },
  );
});

final navigationProvider = Provider<DLNavigation>((ref) {
  final router = ref.watch(appRouterProvider);
  return DLNavigation(router);
});
