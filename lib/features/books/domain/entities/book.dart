class Book {
  final int id;
  final String title;
  final String author;
  final String isbn;
  final int publishedYear;
  final int totalCopies;
  final int availableCopies;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.publishedYear,
    required this.totalCopies,
    required this.availableCopies,
  });

  bool get isAvailable => availableCopies > 0;
}
