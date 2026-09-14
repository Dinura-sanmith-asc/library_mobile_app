import '../entities/member_profile.dart';
import '../repositories/member_repository.dart';

class GetMyProfile {
  final MemberRepository repository;

  const GetMyProfile(this.repository);

  Future<MemberProfile> call(int memberId) {
    return repository.getMember(memberId);
  }
}
