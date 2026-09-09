import 'package:flutter/material.dart';

import 'core/router/app_router.dart';

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Library',
      routerConfig: appRouter,
    );
  }
}