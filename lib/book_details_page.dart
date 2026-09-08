import 'package:flutter/material.dart';

import 'book.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: Padding(
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

            Text(
              'Author: ${book.author}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Book ID: ${book.id}',
            ),

            const SizedBox(height: 12),

            AvailabilityText(
              isAvailable: book.isAvailable,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class AvailabilityText extends StatelessWidget {
  final bool isAvailable;

  const AvailabilityText({
    super.key,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      isAvailable
          ? 'Status: Available'
          : 'Status: Borrowed',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}