import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/core/storage/secure_storage_service.dart';
import 'package:library_mobile_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:library_mobile_app/features/auth/data/models/auth_model.dart';
import 'package:library_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:library_mobile_app/features/auth/domain/entities/auth_state.dart';

void main() {
  test('login stores the backend session and exposes memberId', () async {
    FlutterSecureStorage.setMockInitialValues({});
    const storage = SecureStorageService();
    final expiresAt = DateTime.now().toUtc().add(const Duration(hours: 1));
    final repository = AuthRepositoryImpl(
      _AuthRemoteDataSource(
        AuthModel(
          accessToken: 'jwt-token',
          role: 'Member',
          memberId: 2,
          expiresAt: expiresAt,
        ),
      ),
      storage,
    );

    final state = await repository.login(email: 'member@test', password: 'pw');

    expect(state.status, AuthStatus.authenticated);
    expect(state.memberId, 2);
    expect(await storage.getAccessToken(), 'jwt-token');
  });

  test('restores a complete, unexpired member session', () async {
    FlutterSecureStorage.setMockInitialValues({});
    const storage = SecureStorageService();
    final expiresAt = DateTime.now().toUtc().add(const Duration(hours: 1));
    await storage.saveSession(
      accessToken: 'jwt-token',
      memberId: 2,
      role: 'Member',
      expiresAt: expiresAt,
    );
    final repository = AuthRepositoryImpl(_AuthRemoteDataSource(null), storage);

    final state = await repository.restoreSession();

    expect(state.status, AuthStatus.authenticated);
    expect(state.role, UserRole.member);
    expect(state.memberId, 2);
  });

  test('clears an expired session', () async {
    FlutterSecureStorage.setMockInitialValues({});
    const storage = SecureStorageService();
    await storage.saveSession(
      accessToken: 'expired-token',
      memberId: 2,
      role: 'Member',
      expiresAt: DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
    );
    final repository = AuthRepositoryImpl(_AuthRemoteDataSource(null), storage);

    final state = await repository.restoreSession();

    expect(state.status, AuthStatus.loggedOut);
    expect(await storage.getAccessToken(), isNull);
  });

  test('clears a restored session for a non-member role', () async {
    FlutterSecureStorage.setMockInitialValues({});
    const storage = SecureStorageService();
    await storage.saveSession(
      accessToken: 'admin-token',
      memberId: 2,
      role: 'Admin',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );
    final repository = AuthRepositoryImpl(_AuthRemoteDataSource(null), storage);

    final state = await repository.restoreSession();

    expect(state.status, AuthStatus.loggedOut);
    expect(await storage.getAccessToken(), isNull);
  });
}

class _AuthRemoteDataSource implements AuthRemoteDataSource {
  final AuthModel? model;

  const _AuthRemoteDataSource(this.model);

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    return model!;
  }
}
