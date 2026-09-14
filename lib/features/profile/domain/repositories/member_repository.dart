import '../entities/member_profile.dart';

abstract class MemberRepository {
  Future<MemberProfile> getMember(int memberId);

  Future<void> updateMember({
    required int memberId,
    required String fullName,
    required String email,
    required String? phoneNumber,
  });
}
