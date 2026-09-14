import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../../domain/entities/borrowing.dart';
import '../providers/borrowing_providers.dart';

class MyBorrowingsPage extends ConsumerWidget {
  const MyBorrowingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borrowingsAsync = ref.watch(myBorrowingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Borrowings')),
      body: borrowingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorView(
          message: _errorMessage(error),
          onRetry: () => ref.invalidate(myBorrowingsProvider),
        ),
        data: (borrowings) {
          if (borrowings.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'You have no borrowing history yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(myBorrowingsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: borrowings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _BorrowingCard(borrowing: borrowings[index]);
              },
            ),
          );
        },
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Failed to load borrowing history.';
  }
}

class _BorrowingCard extends ConsumerWidget {
  final Borrowing borrowing;

  const _BorrowingCard({required this.borrowing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookDetailsProvider(borrowing.bookId));
    final returnAsync = ref.watch(returnBookProvider);
    final returnNotifier = ref.read(returnBookProvider.notifier);
    final isReturningThis =
        returnAsync.isLoading &&
        returnNotifier.activeBorrowingId == borrowing.id;
    final canReturn = borrowing.status != BorrowingStatus.returned;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookAsync.value?.title ?? 'Book #${borrowing.bookId}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Borrowed: '
              '${_formatDate(borrowing.borrowedDate)}',
            ),
            Text('Due: ${_formatDate(borrowing.dueDate)}'),
            if (borrowing.returnedDate != null)
              Text(
                'Returned: '
                '${_formatDate(borrowing.returnedDate!)}',
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatusChip(status: borrowing.status),
                const Spacer(),
                if (canReturn)
                  FilledButton(
                    onPressed: returnAsync.isLoading
                        ? null
                        : () => _returnBook(context, ref),
                    child: isReturningThis
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Return'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _returnBook(BuildContext context, WidgetRef ref) async {
    await ref
        .read(returnBookProvider.notifier)
        .returnBook(borrowingId: borrowing.id, bookId: borrowing.bookId);

    if (!context.mounted) {
      return;
    }

    final result = ref.read(returnBookProvider);
    final message = result.hasError
        ? result.error.toString()
        : 'Book returned successfully.';

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _StatusChip extends StatelessWidget {
  final BorrowingStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      BorrowingStatus.borrowed => ('Borrowed', Colors.blue),
      BorrowingStatus.returned => ('Returned', Colors.green),
      BorrowingStatus.overdue => ('Overdue', Colors.red),
    };

    return Chip(
      label: Text(label),
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final localDate = date.toLocal();
  final month = localDate.month.toString().padLeft(2, '0');
  final day = localDate.day.toString().padLeft(2, '0');

  return '${localDate.year}-$month-$day';
}
