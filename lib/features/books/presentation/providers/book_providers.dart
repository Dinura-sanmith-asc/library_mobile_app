import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/book_remote_data_source.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/usecases/get_book_by_id.dart';
import '../../domain/usecases/get_books.dart';

//Data Source Provider
final bookRemoteDataSourceProvider = Provider<BookRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return BookRemoteDataSourceImpl(apiClient);
});

//Repository Provider
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final remoteDataSource = ref.watch(bookRemoteDataSourceProvider);

  return BookRepositoryImpl(remoteDataSource);
});

//GetBooks Use Case Provider
final getBooksProvider = Provider<GetBooks>((ref) {
  final repository = ref.watch(bookRepositoryProvider);

  return GetBooks(repository);
});

//GetBookById provider
final getBookByIdProvider = Provider<GetBookById>((ref) {
  final repository = ref.watch(bookRepositoryProvider);

  return GetBookById(repository);
});

//Create actual async Books state
final booksProvider = FutureProvider<List<Book>>((ref) async {
  final getBooks = ref.watch(getBooksProvider);

  return getBooks();
});

final bookDetailsProvider = FutureProvider.family<Book, int>((
  ref,
  bookId,
) async {
  final getBookById = ref.watch(getBookByIdProvider);

  return getBookById(bookId);
});
