import '../../domain/entities/book.dart';

class BookModel {
  final int id;
  final String title;
  final String author;
  final bool isAvailable;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.isAvailable,
  });

  Book toEntity() {
    return Book(
      id: id,
      title: title,
      author: author,
      isAvailable: isAvailable,
    );
  }
}