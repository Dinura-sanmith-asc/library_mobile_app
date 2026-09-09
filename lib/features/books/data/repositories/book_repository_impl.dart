import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  final BookDataSource dataSource;

  const BookRepositoryImpl(this.dataSource);

  @override
  Future<List<Book>> getBooks() async {
    final models = await dataSource.getBooks();

    return models
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<Book> getBookById(int id) async {
    final model = await dataSource.getBookById(id);

    return model.toEntity();
  }
}