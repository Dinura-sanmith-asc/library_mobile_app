import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:library_mobile_app/app.dart';
import 'package:library_mobile_app/core/theme/app_theme.dart';
import 'package:library_mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:library_mobile_app/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  testWidgets('app starts with the branded splash screen', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    dotenv.loadFromString(envString: 'BASE_URL=https://library.test');

    await tester.pumpWidget(const ProviderScope(child: LibraryApp()));

    expect(find.text('BlueShelf'), findsOneWidget);
    expect(find.text('Your library, always within reach'), findsOneWidget);

    for (var step = 0; step < 4; step++) {
      await tester.pump(const Duration(milliseconds: 600));
    }
    await tester.pumpAndSettle();

    expect(find.text('A library in your pocket'), findsOneWidget);
  });

  testWidgets('onboarding contains three navigable introduction screens', (
    tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppTheme.light, home: const OnboardingPage()),
      ),
    );

    expect(find.text('A library in your pocket'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Discover books easily'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Stay on top of every loan'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('login uses the shared blue and white design', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    dotenv.loadFromString(envString: 'BASE_URL=https://library.test');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppTheme.light, home: const LoginPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
