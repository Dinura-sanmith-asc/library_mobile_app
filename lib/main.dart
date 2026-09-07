import 'package:flutter/material.dart';

void main() {
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library Management',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Choose what you want to manage',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),

            LibraryMenuCard(
              icon: Icons.book,
              title: 'Books',
              subtitle: 'Browse and manage books',
            ),

            SizedBox(height: 16),

            LibraryMenuCard(
              icon: Icons.people,
              title: 'Members',
              subtitle: 'Manage library members',
            ),

            SizedBox(height: 16),

            LibraryMenuCard(
              icon: Icons.swap_horiz,
              title: 'Borrowings',
              subtitle: 'Borrow and return books',
            ),
          ],
        ),
      ),
    );
  }
}

class LibraryMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const LibraryMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}