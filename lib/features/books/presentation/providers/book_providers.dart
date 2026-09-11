import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/book_data_source.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/usecases/get_book_by_id.dart';
import '../../domain/usecases/get_books.dart';

//Data Source Provider
final bookDataSourceProvider = Provider<BookDataSource>((ref) {
  return MockBookDataSource();
});

//Repository Provider
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final dataSource = ref.watch(
    bookDataSourceProvider,
  );

  return BookRepositoryImpl(
    dataSource,
  );
});

//GetBooks Use Case Provider
final getBooksProvider = Provider<GetBooks>((ref) {
  final repository = ref.watch(
    bookRepositoryProvider,
  );

  return GetBooks(
    repository,
  );
});

//GetBookById provider
final getBookByIdProvider =
    Provider<GetBookById>((ref) {
  final repository = ref.watch(
    bookRepositoryProvider,
  );

  return GetBookById(
    repository,
  );
});

//Create actual async Books state
final booksProvider =
    FutureProvider<List<Book>>((ref) async {
  final getBooks = ref.watch(
    getBooksProvider,
  );

  return getBooks();
});