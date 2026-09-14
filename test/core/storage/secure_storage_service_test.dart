import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/core/storage/secure_storage_service.dart';

void main() {
  test('saves, reads, and clears a session', () async {
    FlutterSecureStorage.setMockInitialValues({});
    const service = SecureStorageService();
    final expiresAt = DateTime.utc(2030, 1, 1);

    await service.saveSession(
      accessToken: 'access-token',
      memberId: 2,
      role: 'Member',
      expiresAt: expiresAt,
    );

    expect(await service.getAccessToken(), 'access-token');
    expect(await service.getMemberId(), 2);
    expect(await service.getRole(), 'Member');
    expect(await service.getExpiresAt(), expiresAt);

    await service.clearSession();

    expect(await service.getAccessToken(), isNull);
    expect(await service.getMemberId(), isNull);
    expect(await service.getRole(), isNull);
    expect(await service.getExpiresAt(), isNull);
  });
}
