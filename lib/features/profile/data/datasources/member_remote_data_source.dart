import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../models/member_profile_model.dart';

abstract class MemberRemoteDataSource {
  Future<MemberProfileModel> getMember(int memberId);

  Future<void> updateMember({
    required int memberId,
    required String fullName,
    required String email,
    required String? phoneNumber,
  });
}

class MemberRemoteDataSourceImpl implements MemberRemoteDataSource {
  final ApiClient apiClient;

  const MemberRemoteDataSourceImpl(this.apiClient);

  @override
  Future<MemberProfileModel> getMember(int memberId) async {
    try {
      final response = await apiClient.dio.get('/api/members/$memberId');

      return MemberProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException.fromDio(
        error,
        unauthorizedMessage: 'Your session is invalid or has expired.',
        forbiddenMessage: 'You do not have permission to view this profile.',
        notFoundMessage: 'Member profile not found.',
        fallbackMessage: 'Failed to load your profile.',
      );
    }
  }

  @override
  Future<void> updateMember({
    required int memberId,
    required String fullName,
    required String email,
    required String? phoneNumber,
  }) async {
    try {
      await apiClient.dio.put(
        '/api/members/$memberId',
        data: {
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
        },
      );
    } on DioException catch (error) {
      final backendMessage = _backendMessage(error);

      throw ApiException.fromDio(
        error,
        badRequestMessage:
            backendMessage ?? 'Please check the profile details and try again.',
        unauthorizedMessage: 'Your session is invalid or has expired.',
        forbiddenMessage: 'You do not have permission to update this profile.',
        notFoundMessage: 'Member profile not found.',
        conflictMessage: 'This email is already used by another member.',
        fallbackMessage: 'Failed to update your profile.',
      );
    }
  }

  String? _backendMessage(DioException error) {
    final data = error.response?.data;

    if (data is! Map) {
      return null;
    }

    for (final key in ['detail', 'message']) {
      final value = data[key];

      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }

    return null;
  }
}
