import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/features/borrowings/data/models/borrowing_model.dart';
import 'package:library_mobile_app/features/borrowings/domain/entities/borrowing.dart';

void main() {
  test('maps every backend field and borrowing status', () {
    final model = BorrowingModel.fromJson({
      'id': 10,
      'bookId': 20,
      'memberId': 30,
      'borrowedDate': '2026-09-01T00:00:00Z',
      'dueDate': '2026-09-15T00:00:00Z',
      'returnedDate': '2026-09-10T00:00:00Z',
      'status': 1,
    });

    final borrowing = model.toEntity();

    expect(borrowing.id, 10);
    expect(borrowing.bookId, 20);
    expect(borrowing.memberId, 30);
    expect(borrowing.borrowedDate, DateTime.utc(2026, 9));
    expect(borrowing.dueDate, DateTime.utc(2026, 9, 15));
    expect(borrowing.returnedDate, DateTime.utc(2026, 9, 10));
    expect(borrowing.status, BorrowingStatus.returned);
  });

  test('maps borrowed and overdue statuses and a null returned date', () {
    Map<String, dynamic> borrowingJson(int status) => {
      'id': 10,
      'bookId': 20,
      'memberId': 30,
      'borrowedDate': '2026-09-01T00:00:00Z',
      'dueDate': '2026-09-15T00:00:00Z',
      'returnedDate': null,
      'status': status,
    };

    final borrowed = BorrowingModel.fromJson(borrowingJson(0));
    final overdue = BorrowingModel.fromJson(borrowingJson(2));

    expect(borrowed.returnedDate, isNull);
    expect(borrowed.status, BorrowingStatus.borrowed);
    expect(overdue.status, BorrowingStatus.overdue);
  });
}
