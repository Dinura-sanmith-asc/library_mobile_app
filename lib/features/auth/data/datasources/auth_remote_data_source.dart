import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl
    implements AuthRemoteDataSource {
  final ApiClient apiClient;

  const AuthRemoteDataSourceImpl(
    this.apiClient,
  );

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/REPLACE_WITH_LOGIN_ENDPOINT',
        data: {
          'email': email,
          'password': password,
        },
      );

      final json =
          response.data as Map<String, dynamic>;

      return AuthModel.fromJson(json);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const ApiException(
          'Invalid email or password',
        );
      }

      throw const ApiException(
        'Unable to login',
      );
    }
  }
}