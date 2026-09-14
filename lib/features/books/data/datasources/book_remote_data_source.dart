import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';
import '../models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBooks();

  Future<BookModel> getBookById(int id);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final ApiClient apiClient;

  const BookRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<BookModel>> getBooks() async {
    try {
      final response = await apiClient.dio.get('/api/books');
      final data = response.data as List<dynamic>;

      return data
          .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(
        error,
        unauthorizedMessage: 'Authentication is required.',
        forbiddenMessage: 'You do not have permission to view books.',
        fallbackMessage: 'Failed to load books.',
      );
    }
  }

  @override
  Future<BookModel> getBookById(int id) async {
    try {
      final response = await apiClient.dio.get('/api/books/$id');

      return BookModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException.fromDio(
        error,
        unauthorizedMessage: 'Authentication is required.',
        forbiddenMessage: 'You do not have permission to view this book.',
        notFoundMessage: 'Book not found.',
        fallbackMessage: 'Failed to load book details.',
      );
    }
  }
}
