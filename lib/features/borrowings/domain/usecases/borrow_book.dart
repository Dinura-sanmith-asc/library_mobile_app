import '../repositories/borrowing_repository.dart';

class BorrowBook {
  final BorrowingRepository repository;

  const BorrowBook(this.repository);

  Future<void> call({required int bookId, required int memberId}) {
    return repository.borrowBook(bookId: bookId, memberId: memberId);
  }
}
