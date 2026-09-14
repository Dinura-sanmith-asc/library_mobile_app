import '../repositories/member_repository.dart';

class UpdateMyProfile {
  final MemberRepository repository;

  const UpdateMyProfile(this.repository);

  Future<void> call({
    required int memberId,
    required String fullName,
    required String email,
    required String? phoneNumber,
  }) {
    return repository.updateMember(
      memberId: memberId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
