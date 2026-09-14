abstract class BorrowingRepository {
  Future<void> borrowBook({required int bookId, required int memberId});
}
