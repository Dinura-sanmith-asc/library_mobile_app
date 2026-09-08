import 'package:flutter/material.dart';

import 'book.dart';
import 'book_details_page.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

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
    );
  }
}