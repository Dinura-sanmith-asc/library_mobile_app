import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';

class LibraryApp extends ConsumerWidget {
  const LibraryApp({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final router = ref.watch(
      routerProvider,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Library',
      routerConfig: router,
    );
  }
}