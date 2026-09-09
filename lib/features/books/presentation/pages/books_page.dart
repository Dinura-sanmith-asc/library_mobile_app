import 'package:flutter/material.dart';

import '../../../../book.dart';
import 'book_details_page.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  String searchQuery = '';
  bool isLoading = true;

  final List<Book> books = [
    const Book(
      id: 1,
      title: 'Clean Code',
      author: 'Robert C. Martin',
      isAvailable: true,
    ),
    const Book(
      id: 2,
      title: 'The Pragmatic Programmer',
      author: 'Andrew Hunt',
      isAvailable: false,
    ),
    const Book(
      id: 3,
      title: 'Flutter in Action',
      author: 'Eric Windmill',
      isAvailable: true,
    ),
    const Book(
      id: 4,
      title: 'Design Patterns',
      author: 'Erich Gamma',
      isAvailable: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      final title = book.title.toLowerCase();
      final author = book.author.toLowerCase();
      final query = searchQuery.toLowerCase();

      return title.contains(query) || author.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                              final book = filteredBooks[index];

                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.book),
                                  title: Text(book.title),
                                  subtitle: Text(book.author),
                                  trailing: Text(
                                    book.isAvailable
                                        ? 'Available'
                                        : 'Borrowed',
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BookDetailsPage(
                                            book: book,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}