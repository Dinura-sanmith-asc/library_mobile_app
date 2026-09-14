import '../../domain/entities/auth_state.dart';

class AuthModel {
  final String accessToken;
  final String role;
  final int memberId;
  final DateTime expiresAt;

  const AuthModel({
    required this.accessToken,
    required this.role,
    required this.memberId,
    required this.expiresAt,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['accessToken'] as String,
      role: json['role'] as String,
      memberId: json['memberId'] as int,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  AuthState toEntity() {
    return AuthState(
      status: AuthStatus.authenticated,
      role: role.toLowerCase() == 'member' ? UserRole.member : UserRole.admin,
      memberId: memberId,
      expiresAt: expiresAt,
    );
  }
}
