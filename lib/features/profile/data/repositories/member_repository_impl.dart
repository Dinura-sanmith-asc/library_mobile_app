import '../../domain/entities/member_profile.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/member_remote_data_source.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MemberRemoteDataSource remoteDataSource;

  const MemberRepositoryImpl(this.remoteDataSource);

  @override
  Future<MemberProfile> getMember(int memberId) async {
    final model = await remoteDataSource.getMember(memberId);

    return model.toEntity();
  }

  @override
  Future<void> updateMember({
    required int memberId,
    required String fullName,
    required String email,
    required String? phoneNumber,
  }) {
    return remoteDataSource.updateMember(
      memberId: memberId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
