import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _accessTokenKey = 'access_token';
  static const _memberIdKey = 'member_id';
  static const _roleKey = 'role';
  static const _expiresAtKey = 'expires_at';
  static const _onboardingCompleteKey = 'onboarding_complete';

  final FlutterSecureStorage _storage;

  const SecureStorageService([this._storage = const FlutterSecureStorage()]);

  Future<void> saveAccessToken(String token) {
    return _storage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<void> deleteAccessToken() {
    return _storage.delete(key: _accessTokenKey);
  }

  Future<void> saveSession({
    required String accessToken,
    required int memberId,
    required String role,
    required DateTime expiresAt,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      _storage.write(key: _memberIdKey, value: memberId.toString()),
      _storage.write(key: _roleKey, value: role),
      _storage.write(
        key: _expiresAtKey,
        value: expiresAt.toUtc().toIso8601String(),
      ),
    ]);
  }

  Future<int?> getMemberId() async {
    final value = await _storage.read(key: _memberIdKey);

    return value == null ? null : int.tryParse(value);
  }

  Future<String?> getRole() {
    return _storage.read(key: _roleKey);
  }

  Future<DateTime?> getExpiresAt() async {
    final value = await _storage.read(key: _expiresAtKey);

    return value == null ? null : DateTime.tryParse(value);
  }

  Future<void> clearSession() async {
    await Future.wait([
      deleteAccessToken(),
      _storage.delete(key: _memberIdKey),
      _storage.delete(key: _roleKey),
      _storage.delete(key: _expiresAtKey),
    ]);
  }

  Future<bool> hasCompletedOnboarding() async {
    return await _storage.read(key: _onboardingCompleteKey) == 'true';
  }

  Future<void> completeOnboarding() {
    return _storage.write(key: _onboardingCompleteKey, value: 'true');
  }
}
