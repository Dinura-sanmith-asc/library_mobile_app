import 'package:flutter_test/flutter_test.dart';

import 'package:library_mobile_app/books_page.dart';
import 'package:library_mobile_app/main.dart';

void main() {
  testWidgets('Home page opens the books list', (WidgetTester tester) async {
    await tester.pumpWidget(const LibraryApp());

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Members'), findsOneWidget);
    expect(find.text('Borrowings'), findsOneWidget);

    await tester.tap(find.text('Books'));
    await tester.pumpAndSettle();

    expect(find.byType(BooksPage), findsOneWidget);
    expect(find.text('Clean Code'), findsOneWidget);
    expect(find.text('The Pragmatic Programmer'), findsOneWidget);
    expect(find.text('Available'), findsNWidgets(3));
    expect(find.text('Borrowed'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
  });
}
