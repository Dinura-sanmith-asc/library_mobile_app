import '../repositories/borrowing_repository.dart';

class ReturnBook {
  final BorrowingRepository repository;

  const ReturnBook(this.repository);

  Future<void> call(int borrowingId) {
    return repository.returnBook(borrowingId);
  }
}
