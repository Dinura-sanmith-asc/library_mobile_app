import 'package:go_router/go_router.dart';

import '../../features/books/presentation/pages/book_details_page.dart';
import '../../features/books/presentation/pages/books_page.dart';
import '../../features/borrowings/presentation/pages/my_borrowings_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import 'main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '/books',
          builder: (context, state) {
            return const BooksPage();
          },
        ),
        GoRoute(
          path: '/my-borrowings',
          builder: (context, state) {
            return const MyBorrowingsPage();
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) {
            return const ProfilePage();
          },
        ),
      ],
    ),

    GoRoute(
      path: '/books/:id',
      builder: (context, state) {
        final id = int.parse(
          state.pathParameters['id']!,
        );

        return BookDetailsPage(
          bookId: id,
        );
      },
    ),
  ],
);