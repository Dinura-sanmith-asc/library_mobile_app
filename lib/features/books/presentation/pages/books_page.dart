import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/book.dart';
import '../../domain/usecases/get_books.dart';

class BooksPage extends StatefulWidget {
  final GetBooks getBooks;

  const BooksPage({
    super.key,
    required this.getBooks,
  });

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Book> books = [];

  String searchQuery = '';

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final result = await widget.getBooks();

      debugPrint('BOOKS PAGE RESULT: ${result.length}');
      
      if (!mounted) {
        return;
      }

      setState(() {
        books = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = 'Failed to load books';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      final query = searchQuery.toLowerCase();

      return book.title
              .toLowerCase()
              .contains(query) ||
          book.author
              .toLowerCase()
              .contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: _buildBody(filteredBooks),
    );
  }

  Widget _buildBody(List<Book> filteredBooks) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!),
      );
    }

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
            child: filteredBooks.isEmpty
                ? const Center(
                    child: Text('No books found'),
                  )
                : ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book =
                          filteredBooks[index];

                      return Card(
                        child: ListTile(
                          leading:
                              const Icon(Icons.book),
                          title: Text(book.title),
                          subtitle:
                              Text(book.author),
                          trailing: Text(
                            book.isAvailable
                                ? 'Available'
                                : 'Borrowed',
                          ),
                          onTap: () {
                            context.push(
                              '/books/${book.id}',
                            );
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
}