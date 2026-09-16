import '../../domain/entities/book.dart';

class BookModel {
  final int id;
  final String title;
  final String author;
  final String isbn;
  final int publishedYear;
  final int totalCopies;
  final int availableCopies;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.publishedYear,
    required this.totalCopies,
    required this.availableCopies,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String,
      publishedYear: json['publishedYear'] as int,
      totalCopies: json['totalCopies'] as int,
      availableCopies: json['availableCopies'] as int,
    );
  }

  Book toEntity() {
    return Book(
      id: id,
      title: title,
      author: author,
      isbn: isbn,
      publishedYear: publishedYear,
      totalCopies: totalCopies,
      availableCopies: availableCopies,
    );
  }
}
