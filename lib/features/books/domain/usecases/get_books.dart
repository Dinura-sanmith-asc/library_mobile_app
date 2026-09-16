import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooks {
  final BookRepository repository;

  const GetBooks(this.repository);

  Future<List<Book>> call() {
    return repository.getBooks();
  }
}
