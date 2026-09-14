import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';

abstract class BorrowingRemoteDataSource {
  Future<void> borrowBook({required int bookId, required int memberId});
}

class BorrowingRemoteDataSourceImpl implements BorrowingRemoteDataSource {
  final ApiClient apiClient;

  const BorrowingRemoteDataSourceImpl(this.apiClient);

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
