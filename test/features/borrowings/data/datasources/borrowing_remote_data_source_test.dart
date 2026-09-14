import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/core/api/api_client.dart';
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

    expect(adapter.lastRequest?.path, '/api/members/30/borrowings');
    expect(adapter.lastRequest?.headers['Authorization'], 'Bearer jwt-token');
    expect(borrowings, hasLength(1));
    expect(borrowings.single.memberId, 30);
  });
}

class _BorrowingApiAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;

    return ResponseBody.fromString(
      jsonEncode([
        {
          'id': 10,
          'bookId': 20,
          'memberId': 30,
          'borrowedDate': '2026-09-01T00:00:00Z',
          'dueDate': '2026-09-15T00:00:00Z',
          'returnedDate': null,
          'status': 0,
        },
      ]),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
