import '../entities/auth_state.dart';

abstract class AuthRepository {
  Future<AuthState> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}