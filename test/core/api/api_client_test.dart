import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/core/api/api_client.dart';
import 'package:library_mobile_app/core/api/api_exception.dart';
import 'package:library_mobile_app/core/storage/secure_storage_service.dart';

void main() {
  setUp(() {
    dotenv.loadFromString(envString: 'BASE_URL=https://library.test');
  });

  test('attaches the stored bearer token', () async {
    FlutterSecureStorage.setMockInitialValues({});
    const storage = SecureStorageService();
    await storage.saveAccessToken('jwt-token');
    final adapter = _RecordingAdapter();
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;

    await client.dio.get('/api/books');

    expect(adapter.options?.headers['Authorization'], 'Bearer jwt-token');
  });

  test('does not attach authorization when no token exists', () async {
    FlutterSecureStorage.setMockInitialValues({});
    const storage = SecureStorageService();
    final adapter = _RecordingAdapter();
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;

    await client.dio.post('/api/auth/login');

    expect(adapter.options?.headers, isNot(contains('Authorization')));
  });

  test('maps 401 and 403 to distinct API exception types', () {
    final unauthorized = ApiException.fromDio(_dioError(401));
    final forbidden = ApiException.fromDio(_dioError(403));

    expect(unauthorized.type, ApiExceptionType.unauthorized);
    expect(forbidden.type, ApiExceptionType.forbidden);
  });
}

DioException _dioError(int statusCode) {
  final options = RequestOptions(path: '/protected');

  return DioException(
    requestOptions: options,
    response: Response<void>(requestOptions: options, statusCode: statusCode),
  );
}

class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? options;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    this.options = options;

    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}
}
