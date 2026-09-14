import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/features/books/domain/entities/book.dart';
import 'package:library_mobile_app/features/books/presentation/providers/book_providers.dart';
import 'package:library_mobile_app/features/borrowings/domain/entities/borrowing.dart';
import 'package:library_mobile_app/features/borrowings/presentation/pages/my_borrowings_page.dart';
import 'package:library_mobile_app/features/borrowings/presentation/providers/borrowing_providers.dart';

void main() {
  testWidgets('shows Return only for borrowings not already returned', (
    tester,
  ) async {
    final borrowedDate = DateTime.utc(2026, 9, 1);
    final dueDate = DateTime.utc(2026, 9, 15);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myBorrowingsProvider.overrideWith(
            (ref) async => [
              Borrowing(
                id: 10,
                bookId: 1,
                memberId: 23,
                borrowedDate: borrowedDate,
                dueDate: dueDate,
                returnedDate: null,
                status: BorrowingStatus.borrowed,
              ),
              Borrowing(
                id: 11,
                bookId: 2,
                memberId: 23,
                borrowedDate: borrowedDate,
                dueDate: dueDate,
                returnedDate: dueDate,
                status: BorrowingStatus.returned,
              ),
            ],
          ),
          bookDetailsProvider.overrideWith(
            (ref, bookId) async => Book(
              id: bookId,
              title: 'Book $bookId',
              author: 'Author',
              isbn: 'ISBN-$bookId',
              publishedYear: 2026,
              totalCopies: 1,
              availableCopies: 1,
            ),
          ),
        ],
        child: const MaterialApp(home: MyBorrowingsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Return'), findsOneWidget);
  });
}
