import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/book.dart';
import '../providers/book_providers.dart';

class BooksPage extends ConsumerStatefulWidget {
  const BooksPage({super.key});

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Explore Books'),
            Text(
              'Find your next read',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: booksAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(child: Text(_errorMessage(error)));
        },
        data: (books) {
          return _buildBooksContent(books);
        },
      ),
    );
  }

  Widget _buildBooksContent(List<Book> books) {
    final filteredBooks = books.where((book) {
      final query = searchQuery.toLowerCase();

      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search by title or author',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: books.isEmpty
                ? const Center(child: Text('No books available'))
                : filteredBooks.isEmpty
                ? const Center(child: Text('No books found'))
                : ListView.separated(
                    itemCount: filteredBooks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];

                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(14),
                          leading: Container(
                            width: 48,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.paleBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            book.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${book.author}\n'
                            'Available: '
                            '${book.availableCopies} / '
                            '${book.totalCopies}',
                            style: const TextStyle(
                              color: AppColors.muted,
                              height: 1.4,
                            ),
                          ),
                          isThreeLine: true,
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: book.isAvailable
                                ? AppColors.primary
                                : AppColors.muted,
                          ),
                          onTap: () {
                            context.push('/books/${book.id}');
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Failed to load books.';
  }
}
