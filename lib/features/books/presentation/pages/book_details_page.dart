import 'package:flutter/material.dart';

import '../../domain/entities/book.dart';
import '../../domain/usecases/get_book_by_id.dart';

class BookDetailsPage extends StatefulWidget {
  final int bookId;

  final GetBookById getBookById;

  const BookDetailsPage({
    super.key,
    required this.bookId,
    required this.getBookById,
  });

  @override
  State<BookDetailsPage> createState() =>
      _BookDetailsPageState();
}

class _BookDetailsPageState
    extends State<BookDetailsPage> {
  Book? book;

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    _loadBook();
  }

  Future<void> _loadBook() async {
    try {
      final result = await widget.getBookById(
        widget.bookId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        book = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = 'Book not found';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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

    final currentBook = book!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            currentBook.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Author: ${currentBook.author}',
          ),
          const SizedBox(height: 12),
          Text(
            'Book ID: ${currentBook.id}',
          ),
          const SizedBox(height: 12),
          Text(
            currentBook.isAvailable
                ? 'Status: Available'
                : 'Status: Borrowed',
          ),
        ],
      ),
    );
  }
}