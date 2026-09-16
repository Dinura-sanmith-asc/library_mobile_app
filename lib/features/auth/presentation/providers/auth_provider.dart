import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AuthRemoteDataSourceImpl(apiClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);

  return AuthRepositoryImpl(
    remoteDataSource,
    ref.watch(secureStorageServiceProvider),
  );
});

final loginUseCaseProvider = Provider<Login>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return Login(repository);
});

final logoutUseCaseProvider = Provider<Logout>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return Logout(repository);
});

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final repository = ref.watch(authRepositoryProvider);

    return repository.restoreSession();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final login = ref.read(loginUseCaseProvider);

      return login(email: email, password: password);
    });
  }

  Future<void> logout() async {
    final logout = ref.read(logoutUseCaseProvider);

    await logout();

    state = const AsyncData(AuthState(status: AuthStatus.loggedOut));
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
