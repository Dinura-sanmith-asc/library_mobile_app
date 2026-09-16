import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/features/auth/domain/entities/auth_state.dart';
import 'package:library_mobile_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_mobile_app/features/profile/domain/entities/member_profile.dart';
import 'package:library_mobile_app/features/profile/domain/repositories/member_repository.dart';
import 'package:library_mobile_app/features/profile/presentation/providers/profile_providers.dart';

void main() {
  test(
    'uses the authenticated memberId for profile reads and updates',
    () async {
      final repository = _MemberRepository();
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWithBuild(
            (ref, notifier) async => const AuthState(
              status: AuthStatus.authenticated,
              role: UserRole.member,
              memberId: 23,
            ),
          ),
          memberRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      final profileSubscription = container.listen(
        myProfileProvider,
        (previous, next) {},
      );
      addTearDown(profileSubscription.close);
      final initialProfile = await container.read(myProfileProvider.future);
      await container.read(updateMyProfileProvider.future);

      expect(repository.readMemberId, 23);
      expect(initialProfile.fullName, 'Demo Member');

      await container
          .read(updateMyProfileProvider.notifier)
          .saveProfile(
            fullName: 'John Doe',
            email: 'john@example.com',
            phoneNumber: null,
          );

      final updatedProfile = await container.read(myProfileProvider.future);
      expect(repository.updateMemberId, 23);
      expect(repository.updatedFullName, 'John Doe');
      expect(repository.updatedEmail, 'john@example.com');
      expect(updatedProfile.fullName, 'John Doe');
    },
  );
}

class _MemberRepository implements MemberRepository {
  int? readMemberId;
  int? updateMemberId;
  String? updatedFullName;
  String? updatedEmail;
  MemberProfile profile = MemberProfile(
    id: 23,
    fullName: 'Demo Member',
    email: 'member@library.local',
    phoneNumber: null,
    registeredDate: DateTime.utc(2026, 9, 14),
    isActive: true,
  );

  @override
  Future<MemberProfile> getMember(int memberId) async {
    readMemberId = memberId;
    return profile;
  }

  @override
  Future<void> updateMember({
    required int memberId,
    required String fullName,
    required String email,
    required String? phoneNumber,
  }) async {
    updateMemberId = memberId;
    updatedFullName = fullName;
    updatedEmail = email;
    profile = MemberProfile(
      id: profile.id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      registeredDate: profile.registeredDate,
      isActive: profile.isActive,
    );
  }
}
