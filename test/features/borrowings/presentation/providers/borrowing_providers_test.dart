import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/features/auth/domain/entities/auth_state.dart';
import 'package:library_mobile_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_mobile_app/features/borrowings/domain/entities/borrowing.dart';
import 'package:library_mobile_app/features/borrowings/domain/repositories/borrowing_repository.dart';
import 'package:library_mobile_app/features/borrowings/presentation/providers/borrowing_providers.dart';

void main() {
  test('uses session memberId and prevents duplicate submissions', () async {
    final repository = _BorrowingRepository();
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWithBuild(
          (ref, notifier) async => const AuthState(
            status: AuthStatus.authenticated,
            role: UserRole.member,
            memberId: 23,
          ),
        ),
        borrowingRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authProvider.future);
    await container.read(borrowBookProvider.future);
    final historySubscription = container.listen(
      myBorrowingsProvider,
      (previous, next) {},
    );
    addTearDown(historySubscription.close);
    await container.read(myBorrowingsProvider.future);

    final firstSubmission = container
        .read(borrowBookProvider.notifier)
        .borrowBook(7);
    await Future<void>.delayed(Duration.zero);
    final duplicateSubmission = container
        .read(borrowBookProvider.notifier)
        .borrowBook(7);
    await duplicateSubmission;

    expect(repository.callCount, 1);
    expect(repository.bookId, 7);
    expect(repository.memberId, 23);
    expect(repository.historyMemberId, 23);
    expect(repository.historyCallCount, 1);

    repository.completer.complete();
    await firstSubmission;
    await container.read(myBorrowingsProvider.future);

    expect(container.read(borrowBookProvider).hasError, isFalse);
    expect(repository.historyCallCount, 2);
  });
}

class _BorrowingRepository implements BorrowingRepository {
  final completer = Completer<void>();
  int callCount = 0;
  int historyCallCount = 0;
  int? bookId;
  int? memberId;
  int? historyMemberId;

  @override
  Future<List<Borrowing>> getMemberBorrowings(int memberId) async {
    historyCallCount++;
    historyMemberId = memberId;

    return [];
  }

  @override
  Future<void> borrowBook({required int bookId, required int memberId}) {
    callCount++;
    this.bookId = bookId;
    this.memberId = memberId;

    return completer.future;
  }
}
