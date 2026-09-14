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

  test('loads history from the member-scoped endpoint with JWT', () async {
    const storage = SecureStorageService();
    await storage.saveAccessToken('jwt-token');
    final adapter = _BorrowingApiAdapter();
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
    final dataSource = BorrowingRemoteDataSourceImpl(client);

    final borrowings = await dataSource.getMemberBorrowings(30);

    expect(adapter.request?.method, 'GET');
    expect(adapter.request?.path, '/api/members/30/borrowings');
    expect(adapter.request?.headers['Authorization'], 'Bearer jwt-token');
    expect(borrowings, hasLength(1));
    expect(borrowings.single.memberId, 30);
  });

  test('posts the book and authenticated member IDs with JWT', () async {
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

  test('posts return endpoint without a request body', () async {
    const storage = SecureStorageService();
    await storage.saveAccessToken('jwt-token');
    final adapter = _BorrowingApiAdapter();
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
    final dataSource = BorrowingRemoteDataSourceImpl(client);

    await dataSource.returnBook(10);

    expect(adapter.request?.method, 'POST');
    expect(adapter.request?.path, '/api/borrowings/10/return');
    expect(adapter.request?.headers['Authorization'], 'Bearer jwt-token');
    expect(adapter.request?.data, isNull);
  });

  for (final testCase in [
    (
      statusCode: 401,
      code: 'authentication_required',
      type: ApiExceptionType.unauthorized,
      message: 'Your session is invalid or has expired.',
    ),
    (
      statusCode: 403,
      code: 'forbidden_borrowing_return',
      type: ApiExceptionType.forbidden,
      message: 'You do not have permission to return this borrowing.',
    ),
    (
      statusCode: 404,
      code: 'borrowing_not_found',
      type: ApiExceptionType.notFound,
      message: 'Borrowing record not found.',
    ),
    (
      statusCode: 404,
      code: 'book_not_found',
      type: ApiExceptionType.notFound,
      message: 'Book not found.',
    ),
    (
      statusCode: 409,
      code: 'book_already_returned',
      type: ApiExceptionType.conflict,
      message: 'This book has already been returned.',
    ),
    (
      statusCode: 500,
      code: 'server_error',
      type: ApiExceptionType.network,
      message: 'Unable to return the book. Please try again.',
    ),
  ]) {
    test('maps return ${testCase.code} to a friendly error', () async {
      const storage = SecureStorageService();
      final adapter = _BorrowingApiAdapter(
        returnStatusCode: testCase.statusCode,
        returnErrorCode: testCase.code,
      );
      final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
      final dataSource = BorrowingRemoteDataSourceImpl(client);

      expect(
        dataSource.returnBook(10),
        throwsA(
          isA<ApiException>()
              .having((error) => error.type, 'type', testCase.type)
              .having((error) => error.message, 'message', testCase.message),
        ),
      );
    });
  }

  for (final testCase in [
    (statusCode: 400, type: ApiExceptionType.badRequest),
    (statusCode: 403, type: ApiExceptionType.forbidden),
    (statusCode: 404, type: ApiExceptionType.notFound),
    (statusCode: 409, type: ApiExceptionType.conflict),
  ]) {
    test('maps POST ${testCase.statusCode} to ${testCase.type.name}', () async {
      const storage = SecureStorageService();
      final adapter = _BorrowingApiAdapter(postStatusCode: testCase.statusCode);
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
  final int postStatusCode;
  final int returnStatusCode;
  final String? returnErrorCode;
  RequestOptions? request;

  _BorrowingApiAdapter({
    this.postStatusCode = 201,
    this.returnStatusCode = 200,
    this.returnErrorCode,
  });

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    final isHistoryRequest = options.method == 'GET';
    final isReturnRequest = options.path.endsWith('/return');
    final body = isHistoryRequest
        ? jsonEncode([
            {
              'id': 10,
              'bookId': 20,
              'memberId': 30,
              'borrowedDate': '2026-09-01T00:00:00Z',
              'dueDate': '2026-09-15T00:00:00Z',
              'returnedDate': null,
              'status': 0,
            },
          ])
        : isReturnRequest
        ? jsonEncode({'id': 10, 'code': returnErrorCode})
        : jsonEncode({'id': 1, 'detail': 'Backend borrowing message.'});

    return ResponseBody.fromString(
      body,
      isHistoryRequest
          ? 200
          : isReturnRequest
          ? returnStatusCode
          : postStatusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
