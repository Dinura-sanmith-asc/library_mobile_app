import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:library_mobile_app/app.dart';

void main() {
  testWidgets('fresh session opens the login page', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    dotenv.loadFromString(envString: 'BASE_URL=https://library.test');

    await tester.pumpWidget(const ProviderScope(child: LibraryApp()));
    await tester.pumpAndSettle();

    expect(find.text('Library Login'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
