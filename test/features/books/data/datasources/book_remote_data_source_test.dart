import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/core/api/api_client.dart';
import 'package:library_mobile_app/core/api/api_exception.dart';
import 'package:library_mobile_app/core/storage/secure_storage_service.dart';
import 'package:library_mobile_app/features/books/data/datasources/book_remote_data_source.dart';

void main() {
  setUp(() {
    dotenv.loadFromString(envString: 'BASE_URL=https://library.test');
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('loads books from GET /api/books with the stored token', () async {
    const storage = SecureStorageService();
    await storage.saveAccessToken('jwt-token');
    final adapter = _BookApiAdapter();
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
    final dataSource = BookRemoteDataSourceImpl(client);

    final books = await dataSource.getBooks();

    expect(adapter.lastRequest?.path, '/api/books');
    expect(adapter.lastRequest?.headers['Authorization'], 'Bearer jwt-token');
    expect(books, hasLength(1));
    expect(books.single.title, 'Clean Code');
    expect(books.single.availableCopies, 3);
  });

  test('maps a missing book to a not-found API exception', () async {
    const storage = SecureStorageService();
    final adapter = _BookApiAdapter(statusCode: 404);
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
    final dataSource = BookRemoteDataSourceImpl(client);

    expect(
      dataSource.getBookById(42),
      throwsA(
        isA<ApiException>()
            .having((error) => error.type, 'type', ApiExceptionType.notFound)
            .having((error) => error.message, 'message', 'Book not found.'),
      ),
    );
  });

  test('keeps forbidden distinct from unauthorized', () async {
    const storage = SecureStorageService();
    final adapter = _BookApiAdapter(statusCode: 403);
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
    final dataSource = BookRemoteDataSourceImpl(client);

    expect(
      dataSource.getBooks(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.type,
          'type',
          ApiExceptionType.forbidden,
        ),
      ),
    );
  });
}

class _BookApiAdapter implements HttpClientAdapter {
  final int statusCode;
  RequestOptions? lastRequest;

  _BookApiAdapter({this.statusCode = 200});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    final body = options.path == '/api/books'
        ? jsonEncode([
            {
              'id': 1,
              'title': 'Clean Code',
              'author': 'Robert C. Martin',
              'isbn': '978-0132350884',
              'publishedYear': 2008,
              'totalCopies': 5,
              'availableCopies': 3,
            },
          ])
        : jsonEncode({'statusCode': statusCode, 'message': 'Book not found.'});

    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
