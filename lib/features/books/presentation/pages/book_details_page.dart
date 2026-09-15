import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
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
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Container(
                        width: 92,
                        height: 112,
                        decoration: BoxDecoration(
                          color: AppColors.paleBlue,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          size: 46,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        book.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        book.author,
                        style: const TextStyle(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _DetailRow(label: 'ISBN', value: book.isbn),
                      _DetailRow(
                        label: 'Published',
                        value: '${book.publishedYear}',
                      ),
                      _DetailRow(
                        label: 'Available copies',
                        value: '${book.availableCopies} of ${book.totalCopies}',
                      ),
                      _DetailRow(
                        label: 'Status',
                        value: book.isAvailable ? 'Available' : 'Unavailable',
                        valueColor: book.isAvailable
                            ? AppColors.primary
                            : AppColors.muted,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: borrowAsync.isLoading
                    ? null
                    : () => _borrowBook(context, ref),
                icon: const Icon(Icons.bookmark_add_outlined),
                label: borrowAsync.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Borrow Book'),
              ),
            ],
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool showDivider;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              Text(label, style: const TextStyle(color: AppColors.muted)),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}
