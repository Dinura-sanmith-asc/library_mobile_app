import '../../domain/entities/borrowing.dart';

class BorrowingModel {
  final int id;
  final int bookId;
  final int memberId;
  final DateTime borrowedDate;
  final DateTime dueDate;
  final DateTime? returnedDate;
  final BorrowingStatus status;

  const BorrowingModel({
    required this.id,
    required this.bookId,
    required this.memberId,
    required this.borrowedDate,
    required this.dueDate,
    required this.returnedDate,
    required this.status,
  });

  factory BorrowingModel.fromJson(Map<String, dynamic> json) {
    return BorrowingModel(
      id: json['id'] as int,
      bookId: json['bookId'] as int,
      memberId: json['memberId'] as int,
      borrowedDate: DateTime.parse(json['borrowedDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      returnedDate: json['returnedDate'] == null
          ? null
          : DateTime.parse(json['returnedDate'] as String),
      status: _statusFromJson(json['status'] as int),
    );
  }

  static BorrowingStatus _statusFromJson(int status) {
    return switch (status) {
      0 => BorrowingStatus.borrowed,
      1 => BorrowingStatus.returned,
      2 => BorrowingStatus.overdue,
      _ => throw FormatException('Unknown borrowing status: $status'),
    };
  }

  Borrowing toEntity() {
    return Borrowing(
      id: id,
      bookId: bookId,
      memberId: memberId,
      borrowedDate: borrowedDate,
      dueDate: dueDate,
      returnedDate: returnedDate,
      status: status,
    );
  }
}
