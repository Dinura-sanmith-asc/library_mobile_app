import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(
      status: AuthStatus.loggedOut,
    );
  }

  void loginAsMember() {
    state = const AuthState(
      status: AuthStatus.authenticated,
      role: UserRole.member,
    );
  }

  void logout() {
    state = const AuthState(
      status: AuthStatus.loggedOut,
    );
  }
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);