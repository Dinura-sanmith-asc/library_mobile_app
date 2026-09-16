enum UserRole { member, admin }

enum AuthStatus { loggedOut, authenticated }

class AuthState {
  final AuthStatus status;
  final UserRole? role;
  final int? memberId;
  final DateTime? expiresAt;

  const AuthState({
    required this.status,
    this.role,
    this.memberId,
    this.expiresAt,
  });

  bool get isLoggedIn {
    return status == AuthStatus.authenticated;
  }
}
