import '../../features/books/data/datasources/book_data_source.dart';
import '../../features/books/data/repositories/book_repository_impl.dart';
import '../../features/books/domain/usecases/get_book_by_id.dart';
import '../../features/books/domain/usecases/get_books.dart';

final bookDataSource = MockBookDataSource();

final bookRepository = BookRepositoryImpl(
  bookDataSource,
);

final getBooksUseCase = GetBooks(
  bookRepository,
);

final getBookByIdUseCase = GetBookById(
  bookRepository,
);