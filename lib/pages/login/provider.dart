import 'dart:convert';

import 'package:fitness_app/pages/login/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState {
  final UserModel? user;
  final bool isLoggedIn;
  final bool isInitialized;

  const UserState({this.user, this.isLoggedIn = false, this.isInitialized = false});

  UserState copyWith({UserModel? user, bool? isLoggedIn, bool? isInitialized}) {
    return UserState(
      user: user ?? this.user,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class UserNotifier extends AsyncNotifier<UserState> {
  final String _userKey = 'user';

  @override
  Future<UserState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);

    if (userStr != null) {
      try {
        final json = jsonDecode(userStr) as Map<String, dynamic>;
        final user = UserModel.fromJson(json);
        return UserState(user: user, isLoggedIn: true, isInitialized: true);
      } catch (_) {
        return const UserState(isInitialized: true);
      }
    }

    return const UserState(isInitialized: true);
  }

  void login(UserModel user) {
    state = AsyncData(state.value!.copyWith(user: user, isLoggedIn: true));
    _saveUserToStorage(user);
  }

  void logout() {
    state = AsyncData(state.value!.copyWith(user: null, isLoggedIn: false));
    _removeUserFromStorage();
  }

  void _saveUserToStorage(UserModel user) {
    final String userStr = jsonEncode(user.toJson());
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_userKey, userStr);
    });
  }

  void _removeUserFromStorage() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(_userKey);
    });
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);
