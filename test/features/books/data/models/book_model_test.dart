import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/features/books/data/models/book_model.dart';

void main() {
  test('maps the backend DTO and derives availability', () {
    final model = BookModel.fromJson({
      'id': 1,
      'title': 'Clean Code',
      'author': 'Robert C. Martin',
      'isbn': '978-0132350884',
      'publishedYear': 2008,
      'totalCopies': 5,
      'availableCopies': 0,
    });

    final book = model.toEntity();

    expect(book.id, 1);
    expect(book.isbn, '978-0132350884');
    expect(book.publishedYear, 2008);
    expect(book.totalCopies, 5);
    expect(book.availableCopies, 0);
    expect(book.isAvailable, isFalse);
  });
}
