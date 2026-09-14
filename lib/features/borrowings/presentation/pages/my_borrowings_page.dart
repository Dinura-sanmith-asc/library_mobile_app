import 'package:flutter/material.dart';

class MyBorrowingsPage extends StatelessWidget {
  const MyBorrowingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Borrowings'),
      ),
      body: const Center(
        child: Text('My Borrowings'),
      ),
    );
  }
}
