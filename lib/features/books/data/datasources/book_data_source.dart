import '../models/book_model.dart';

abstract class BookDataSource {
  Future<List<BookModel>> getBooks();

  Future<BookModel> getBookById(int id);
}

class MockBookDataSource implements BookDataSource {
  final List<BookModel> _books = const [
    BookModel(
      id: 1,
      title: 'Clean Code',
      author: 'Robert C. Martin',
      isAvailable: true,
    ),
    BookModel(
      id: 2,
      title: 'The Pragmatic Programmer',
      author: 'Andrew Hunt',
      isAvailable: false,
    ),
    BookModel(
      id: 3,
      title: 'Flutter in Action',
      author: 'Eric Windmill',
      isAvailable: true,
    ),
    BookModel(
      id: 4,
      title: 'Design Patterns',
      author: 'Erich Gamma',
      isAvailable: true,
    ),
  ];

  @override
  Future<List<BookModel>> getBooks() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return _books;
  }

  @override
  Future<BookModel> getBookById(int id) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return _books.firstWhere(
      (book) => book.id == id,
    );
  }
}