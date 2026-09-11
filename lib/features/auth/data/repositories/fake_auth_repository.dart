import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthState> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 1500),
    );

    if (email == 'member@test.com' &&
        password == '123456') {
      return const AuthState(
        status: AuthStatus.authenticated,
        role: UserRole.member,
      );
    }

    throw Exception('Invalid email or password');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
  }
}