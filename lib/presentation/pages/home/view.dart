import 'package:fitness_app/core/settings/app_settings.dart';
import 'package:fitness_app/core/settings/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    return Center(child: Text(AppText.homePageTitle(locale)));
  }
}
