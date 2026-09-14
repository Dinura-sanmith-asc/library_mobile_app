import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class UnsupportedRolePage extends ConsumerWidget {
  const UnsupportedRolePage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Unsupported'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This mobile app is available for members only.',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(authProvider.notifier)
                    .logout();
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
