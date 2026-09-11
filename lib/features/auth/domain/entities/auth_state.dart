enum UserRole {
  member,
  admin,
}

enum AuthStatus {
  loggedOut,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  final UserRole? role;

  const AuthState({
    required this.status,
    this.role,
  });

  bool get isLoggedIn {
    return status == AuthStatus.authenticated;
  }
}