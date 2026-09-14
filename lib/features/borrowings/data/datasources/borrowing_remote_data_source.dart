import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../models/borrowing_model.dart';

abstract class BorrowingRemoteDataSource {
  Future<List<BorrowingModel>> getMemberBorrowings(int memberId);

  Future<void> borrowBook({required int bookId, required int memberId});
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

  @override
  Future<void> borrowBook({required int bookId, required int memberId}) async {
    try {
      await apiClient.dio.post(
        '/api/borrowings',
        data: {'bookId': bookId, 'memberId': memberId},
      );
    } on DioException catch (error) {
      final backendMessage = _backendMessage(error);

      throw ApiException.fromDio(
        error,
        badRequestMessage: backendMessage ?? 'Unable to borrow this book.',
        unauthorizedMessage: 'Your session is invalid or has expired.',
        forbiddenMessage:
            backendMessage ??
            'You do not have permission to borrow for this member.',
        notFoundMessage: backendMessage ?? 'Book or member not found.',
        conflictMessage:
            backendMessage ??
            'This book is unavailable or your borrowing limit was reached.',
        fallbackMessage: 'Unable to borrow the book. Please try again.',
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
