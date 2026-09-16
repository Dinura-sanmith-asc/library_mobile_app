enum BorrowingStatus { borrowed, returned, overdue }

class Borrowing {
  final int id;
  final int bookId;
  final int memberId;
  final DateTime borrowedDate;
  final DateTime dueDate;
  final DateTime? returnedDate;
  final BorrowingStatus status;

  const Borrowing({
    required this.id,
    required this.bookId,
    required this.memberId,
    required this.borrowedDate,
    required this.dueDate,
    required this.returnedDate,
    required this.status,
  });
}
