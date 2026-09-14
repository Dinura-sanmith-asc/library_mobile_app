import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  const BookRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Book>> getBooks() async {
    final models = await remoteDataSource.getBooks();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Book> getBookById(int id) async {
    final model = await remoteDataSource.getBookById(id);

    return model.toEntity();
  }
}
