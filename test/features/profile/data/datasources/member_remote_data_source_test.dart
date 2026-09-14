import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/core/api/api_client.dart';
import 'package:library_mobile_app/core/api/api_exception.dart';
import 'package:library_mobile_app/core/storage/secure_storage_service.dart';
import 'package:library_mobile_app/features/profile/data/datasources/member_remote_data_source.dart';

void main() {
  setUp(() {
    dotenv.loadFromString(envString: 'BASE_URL=https://library.test');
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('gets and updates only the requested member using the JWT', () async {
    const storage = SecureStorageService();
    await storage.saveAccessToken('jwt-token');
    final adapter = _MemberApiAdapter();
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
    final dataSource = MemberRemoteDataSourceImpl(client);

    final profile = await dataSource.getMember(2);

    expect(profile.id, 2);
    expect(adapter.requests.single.path, '/api/members/2');
    expect(
      adapter.requests.single.headers['Authorization'],
      'Bearer jwt-token',
    );

    await dataSource.updateMember(
      memberId: 2,
      fullName: 'John Doe',
      email: 'john@example.com',
      phoneNumber: '+94771234567',
    );

    final updateRequest = adapter.requests.last;
    expect(updateRequest.method, 'PUT');
    expect(updateRequest.path, '/api/members/2');
    expect(updateRequest.data, {
      'fullName': 'John Doe',
      'email': 'john@example.com',
      'phoneNumber': '+94771234567',
    });
    expect((updateRequest.data as Map).containsKey('isActive'), isFalse);
  });

  test('maps an update conflict to the duplicate email message', () async {
    const storage = SecureStorageService();
    final adapter = _MemberApiAdapter(updateStatusCode: 409);
    final client = ApiClient(storage)..dio.httpClientAdapter = adapter;
    final dataSource = MemberRemoteDataSourceImpl(client);

    expect(
      dataSource.updateMember(
        memberId: 2,
        fullName: 'John Doe',
        email: 'used@example.com',
        phoneNumber: null,
      ),
      throwsA(
        isA<ApiException>()
            .having((error) => error.type, 'type', ApiExceptionType.conflict)
            .having(
              (error) => error.message,
              'message',
              'This email is already used by another member.',
            ),
      ),
    );
  });
}

class _MemberApiAdapter implements HttpClientAdapter {
  final int updateStatusCode;
  final List<RequestOptions> requests = [];

  _MemberApiAdapter({this.updateStatusCode = 204});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);

    if (options.method == 'PUT') {
      return ResponseBody.fromString('', updateStatusCode);
    }

    return ResponseBody.fromString(
      jsonEncode({
        'id': 2,
        'fullName': 'Demo Member',
        'email': 'member@library.local',
        'phoneNumber': null,
        'registeredDate': '2026-09-14T06:00:00Z',
        'isActive': true,
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
