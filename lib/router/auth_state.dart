import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = NotifierProvider<AuthStateController, bool>(
  AuthStateController.new,
);

class AuthStateController extends Notifier<bool> {
  @override
  bool build() => true;

  void signIn() {
    state = true;
  }

  void signOut() {
    state = false;
  }
}
