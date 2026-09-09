import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Browse Books'),
              subtitle: const Text(
                'Find and view library books',
              ),
              onTap: () {
                context.go('/books');
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('My Borrowings'),
              subtitle: const Text(
                'View your borrowed books',
              ),
              onTap: () {
                context.go('/my-borrowings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              subtitle: const Text(
                'View and update your profile',
              ),
              onTap: () {
                context.go('/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}