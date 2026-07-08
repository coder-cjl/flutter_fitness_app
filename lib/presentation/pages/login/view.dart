import 'package:fitness_app/router/auth_state.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('LoginPage'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ref.read(authStateProvider.notifier).signIn();
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
