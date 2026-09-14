import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../models/borrowing_model.dart';

abstract class BorrowingRemoteDataSource {
  Future<List<BorrowingModel>> getMemberBorrowings(int memberId);
}

class BorrowingRemoteDataSourceImpl implements BorrowingRemoteDataSource {
  final ApiClient apiClient;

  const BorrowingRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<BorrowingModel>> getMemberBorrowings(int memberId) async {
    try {
      final response = await apiClient.dio.get(
        '/api/members/$memberId/borrowings',
      );
      final data = response.data as List<dynamic>;

      return data
          .map((item) => BorrowingModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(
        error,
        unauthorizedMessage: 'Authentication is required.',
        forbiddenMessage: 'You do not have permission to view borrowings.',
        notFoundMessage: 'Member borrowing history was not found.',
        fallbackMessage: 'Failed to load borrowing history.',
      );
    }
  }
}
