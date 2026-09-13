import '../../domain/entities/auth_state.dart';

class AuthModel {
  final String accessToken;
  final String role;

  const AuthModel({
    required this.accessToken,
    required this.role,
  });

  factory AuthModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AuthModel(
      accessToken:
          json['accessToken'] as String,
      role: json['role'] as String,
    );
  }

  AuthState toEntity() {
    return AuthState(
      status: AuthStatus.authenticated,
      role: role.toLowerCase() == 'member'
          ? UserRole.member
          : UserRole.admin,
    );
  }
}