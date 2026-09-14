import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_exception.dart';
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
      appBar: AppBar(title: const Text('Books')),
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
              labelText: 'Search books',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
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
                : ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.book),
                          title: Text(book.title),
                          subtitle: Text(
                            '${book.author}\n'
                            'Available Copies: '
                            '${book.availableCopies} / '
                            '${book.totalCopies}',
                          ),
                          isThreeLine: true,
                          trailing: Text(
                            book.isAvailable ? 'Available' : 'Unavailable',
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
