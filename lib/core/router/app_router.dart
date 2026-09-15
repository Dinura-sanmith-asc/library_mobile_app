import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/unsupported_role_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/books/presentation/pages/book_details_page.dart';
import '../../features/books/presentation/pages/books_page.dart';
import '../../features/borrowings/presentation/pages/my_borrowings_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import 'main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authProvider);

  final authState =
      authAsync.value ?? const AuthState(status: AuthStatus.loggedOut);

  return GoRouter(
    initialLocation: '/splash',

    redirect: (context, state) {
      final location = state.matchedLocation;

      final isLoginPage = location == '/login';

      final isUnsupportedPage = location == '/unsupported';

      final isStartupPage = location == '/splash' || location == '/onboarding';

      if (isStartupPage) {
        return null;
      }

      // 1. Not logged in
      if (!authState.isLoggedIn) {
        if (isLoginPage) {
          return null;
        }

        return '/login';
      }

      // 2. Logged in but not Member
      if (authState.role != UserRole.member) {
        if (isUnsupportedPage) {
          return null;
        }

        return '/unsupported';
      }

      // 3. Logged-in Member trying to open login
      if (isLoginPage || isUnsupportedPage) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) {
          return const SplashPage();
        },
      ),

      GoRoute(
        path: '/onboarding',
        builder: (context, state) {
          return const OnboardingPage();
        },
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginPage();
        },
      ),

      GoRoute(
        path: '/unsupported',
        builder: (context, state) {
          return const UnsupportedRolePage();
        },
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
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

          GoRoute(
            path: '/profile/edit',
            builder: (context, state) {
              return const EditProfilePage();
            },
          ),
        ],
      ),

      GoRoute(
        path: '/books/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);

          return BookDetailsPage(bookId: id);
        },
      ),
    ],
  );
});
