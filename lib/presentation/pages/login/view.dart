import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final appText = ref.watch(appTextProvider);

    return Scaffold(
      appBar: AppBar(title: Text(appText.loginTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(appText.loginPageTitle),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // ref.read(authStateProvider.notifier).signIn();
              },
              child: Text(appText.signInButton),
            ),
          ],
        ),
      ),
    );
  }
}
