import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/fake_auth_repository.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

final loginUseCaseProvider =
    Provider<Login>((ref) {
  final repository = ref.watch(
    authRepositoryProvider,
  );

  return Login(repository);
});

final logoutUseCaseProvider =
    Provider<Logout>((ref) {
  final repository = ref.watch(
    authRepositoryProvider,
  );

  return Logout(repository);
});

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return const AuthState(
      status: AuthStatus.loggedOut,
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final login = ref.read(
        loginUseCaseProvider,
      );

      return login(
        email: email,
        password: password,
      );
    });
  }

  Future<void> logout() async {
    final logout = ref.read(
      logoutUseCaseProvider,
    );

    await logout();

    state = const AsyncData(
      AuthState(
        status: AuthStatus.loggedOut,
      ),
    );
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);