class MemberProfile {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final DateTime registeredDate;
  final bool isActive;

  const MemberProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.registeredDate,
    required this.isActive,
  });
}
