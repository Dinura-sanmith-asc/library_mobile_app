import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBookById {
  final BookRepository repository;

  const GetBookById(this.repository);

  Future<Book> call(int id) {
    return repository.getBookById(id);
  }
}