import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/pages/exercise_detail/provider.dart';
import 'package:fitness_app/pages/exercise_detail/view.dart';
import 'package:fitness_app/pages/login/view.dart';
import 'package:fitness_app/pages/tab/view.dart';
import 'package:fitness_app/router/app_route_url.dart';
import 'package:fitness_app/router/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'tab_module.dart';

final rootNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');
});

final navigationProvider = Provider<DLNavigation>((ref) {
  final router = ref.watch(appRouterProvider);
  return DLNavigation(router);
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = ref.watch(rootNavigatorKeyProvider);
  final authRefreshListenable = ValueNotifier<int>(0);

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
          final tab = TabModule.fromQuery(state.uri.queryParameters['tab']);

          return TabBarPage(activeTab: tab);
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
      GoRoute(
        name: AppRoute.exerciseDetailName,
        path: AppRoute.exerciseDetailPath,
        builder: (context, state) {
          final exercise = ProviderScope.containerOf(context)
              .read(selectedExerciseProvider);
          if (exercise == null) {
            return const Scaffold(
              body: Center(child: Text('Exercise not found')),
            );
          }
          return ExerciseDetailPage(exercise: exercise);
        },
      ),
    ],
    redirect: (context, state) {
      final isOnLogin = state.matchedLocation == AppRoute.loginPath;

      // if (!isOnLogin) {
      //   return Uri(
      //     path: AppRoute.loginPath,
      //     queryParameters: {'from': state.uri.toString()},
      //   ).toString();
      // }

      if (isOnLogin) {
        final from = state.uri.queryParameters['from'];

        if (_isSafeInternalLocation(from) && !_isLoginLocation(from)) {
          return from;
        }

        return AppRoute.tabPath;
      }

      return null;
    },
    errorBuilder: (context, state) {
      final container = ProviderScope.containerOf(context);
      final appText = container.read(appTextProvider);

      return Scaffold(
        appBar: AppBar(title: Text(appText.pageNotFoundTitle)),
        body: Center(
          child: Text(state.error?.toString() ?? appText.unknownRoute),
        ),
      );
    },
  );
});

bool _isSafeInternalLocation(String? location) {
  if (location == null || location.isEmpty) {
    return false;
  }

  final uri = Uri.tryParse(location);
  return uri != null && uri.hasAbsolutePath && !uri.hasAuthority;
}

bool _isLoginLocation(String? location) {
  final uri = Uri.tryParse(location ?? '');
  return uri?.path == AppRoute.loginPath;
}
