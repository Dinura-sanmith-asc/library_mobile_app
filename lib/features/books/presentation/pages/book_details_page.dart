import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../borrowings/presentation/providers/borrowing_providers.dart';
import '../providers/book_providers.dart';

class BookDetailsPage extends ConsumerWidget {
  final int bookId;

  const BookDetailsPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookDetailsProvider(bookId));
    final borrowAsync = ref.watch(borrowBookProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: bookAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(child: Text(_errorMessage(error)));
        },
        data: (book) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Author: ${book.author}'),
                const SizedBox(height: 12),
                Text('ISBN: ${book.isbn}'),
                const SizedBox(height: 12),
                Text(
                  'Published Year: '
                  '${book.publishedYear}',
                ),
                const SizedBox(height: 12),
                Text(
                  'Available Copies: '
                  '${book.availableCopies}',
                ),
                const SizedBox(height: 12),
                Text(
                  'Total Copies: '
                  '${book.totalCopies}',
                ),
                const SizedBox(height: 12),
                Text(
                  book.isAvailable
                      ? 'Status: Available'
                      : 'Status: Unavailable',
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: borrowAsync.isLoading
                        ? null
                        : () => _borrowBook(context, ref),
                    child: borrowAsync.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Borrow Book'),
                  ),
                ),
              ],
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

    return 'Failed to load book details.';
  }

  Future<void> _borrowBook(BuildContext context, WidgetRef ref) async {
    await ref.read(borrowBookProvider.notifier).borrowBook(bookId);

    if (!context.mounted) {
      return;
    }

    final result = ref.read(borrowBookProvider);
    final message = result.hasError
        ? result.error.toString()
        : 'Book borrowed successfully.';

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
