import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref
                .read(authProvider.notifier)
                .loginAsMember();
          },
          child: const Text('Login as Member'),
        ),
      ),
    );
  }
}