import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:library_mobile_app/app.dart';

void main() {
  testWidgets('fresh install opens onboarding after splash', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    dotenv.loadFromString(envString: 'BASE_URL=https://library.test');

    await tester.pumpWidget(const ProviderScope(child: LibraryApp()));
    await tester.pumpAndSettle();

    expect(find.text('A library in your pocket'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('returning signed-out member opens login after splash', (
    tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({'onboarding_complete': 'true'});
    dotenv.loadFromString(envString: 'BASE_URL=https://library.test');

    await tester.pumpWidget(const ProviderScope(child: LibraryApp()));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
