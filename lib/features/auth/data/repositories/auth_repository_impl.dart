import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl
    implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<AuthState> login({
    required String email,
    required String password,
  }) async {
    final model =
        await remoteDataSource.login(
      email: email,
      password: password,
    );

    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    // Later:
    // remove locally stored access token.
  }
}