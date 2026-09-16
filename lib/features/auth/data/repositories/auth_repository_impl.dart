import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorageService;

  const AuthRepositoryImpl(this.remoteDataSource, this.secureStorageService);

  @override
  Future<AuthState> login({
    required String email,
    required String password,
  }) async {
    final model = await remoteDataSource.login(
      email: email,
      password: password,
    );

    await secureStorageService.saveSession(
      accessToken: model.accessToken,
      memberId: model.memberId,
      role: model.role,
      expiresAt: model.expiresAt,
    );

    return model.toEntity();
  }

  @override
  Future<AuthState> restoreSession() async {
    final values = await Future.wait<Object?>([
      secureStorageService.getAccessToken(),
      secureStorageService.getMemberId(),
      secureStorageService.getRole(),
      secureStorageService.getExpiresAt(),
    ]);

    final accessToken = values[0] as String?;
    final memberId = values[1] as int?;
    final role = values[2] as String?;
    final expiresAt = values[3] as DateTime?;
    final isMember = role?.toLowerCase() == 'member';
    final isValid =
        accessToken != null &&
        accessToken.isNotEmpty &&
        memberId != null &&
        isMember &&
        expiresAt != null &&
        expiresAt.isAfter(DateTime.now().toUtc());

    if (!isValid) {
      await secureStorageService.clearSession();

      return const AuthState(status: AuthStatus.loggedOut);
    }

    return AuthState(
      status: AuthStatus.authenticated,
      role: UserRole.member,
      memberId: memberId,
      expiresAt: expiresAt,
    );
  }

  @override
  Future<void> logout() async {
    await secureStorageService.clearSession();
  }
}
