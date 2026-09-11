import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/book_providers.dart';

class BookDetailsPage extends ConsumerWidget {
  final int bookId;

  const BookDetailsPage({
    super.key,
    required this.bookId,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final bookAsync = ref.watch(
      bookDetailsProvider(bookId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: bookAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text('Book not found'),
          );
        },
        data: (book) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Author: ${book.author}',
                ),
                const SizedBox(height: 12),
                Text(
                  'Book ID: ${book.id}',
                ),
                const SizedBox(height: 12),
                Text(
                  book.isAvailable
                      ? 'Status: Available'
                      : 'Status: Borrowed',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}