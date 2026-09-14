import '../entities/borrowing.dart';

abstract class BorrowingRepository {
  Future<List<Borrowing>> getMemberBorrowings(int memberId);
}
