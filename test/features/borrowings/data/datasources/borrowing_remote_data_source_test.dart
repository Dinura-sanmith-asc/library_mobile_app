import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/core/api/api_client.dart';
import 'package:library_mobile_app/core/api/api_exception.dart';
import 'package:library_mobile_app/core/storage/secure_storage_service.dart';
import 'package:library_mobile_app/features/borrowings/data/datasources/borrowing_remote_data_source.dart';

void main() {
  setUp(() {
    dotenv.loadFromString(envString: 'BASE_URL=https://library.test');
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('posts the book and authenticated member IDs with the JWT', () async {
    const storage = SecureStorageService();
    await storage.saveAccessToken('jwt-token');
    final adapter = _BorrowingApiAdapter();
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
    final dataSource = BorrowingRemoteDataSourceImpl(client);

    await dataSource.borrowBook(bookId: 7, memberId: 23);

    expect(adapter.request?.method, 'POST');
    expect(adapter.request?.path, '/api/borrowings');
    expect(adapter.request?.headers['Authorization'], 'Bearer jwt-token');
    expect(adapter.request?.data, {'bookId': 7, 'memberId': 23});
  });

  for (final testCase in [
    (statusCode: 400, type: ApiExceptionType.badRequest),
    (statusCode: 403, type: ApiExceptionType.forbidden),
    (statusCode: 404, type: ApiExceptionType.notFound),
    (statusCode: 409, type: ApiExceptionType.conflict),
  ]) {
    test('maps ${testCase.statusCode} to ${testCase.type.name}', () async {
      const storage = SecureStorageService();
      final adapter = _BorrowingApiAdapter(statusCode: testCase.statusCode);
      final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
      final dataSource = BorrowingRemoteDataSourceImpl(client);

      expect(
        dataSource.borrowBook(bookId: 7, memberId: 23),
        throwsA(
          isA<ApiException>()
              .having((error) => error.type, 'type', testCase.type)
              .having(
                (error) => error.message,
                'message',
                'Backend borrowing message.',
              ),
        ),
      );
    });
  }
}

class _BorrowingApiAdapter implements HttpClientAdapter {
  final int statusCode;
  RequestOptions? request;

  _BorrowingApiAdapter({this.statusCode = 201});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;

    return ResponseBody.fromString(
      jsonEncode({'id': 1, 'detail': 'Backend borrowing message.'}),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
