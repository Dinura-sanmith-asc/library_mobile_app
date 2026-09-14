import '../entities/borrowing.dart';

abstract class BorrowingRepository {
  Future<List<Borrowing>> getMemberBorrowings(int memberId);

  Future<void> borrowBook({required int bookId, required int memberId});
}
