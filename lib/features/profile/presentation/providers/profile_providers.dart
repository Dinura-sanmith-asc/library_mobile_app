import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/member_remote_data_source.dart';
import '../../data/repositories/member_repository_impl.dart';
import '../../domain/entities/member_profile.dart';
import '../../domain/repositories/member_repository.dart';
import '../../domain/usecases/get_my_profile.dart';
import '../../domain/usecases/update_my_profile.dart';

final memberRemoteDataSourceProvider = Provider<MemberRemoteDataSource>((ref) {
  return MemberRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(ref.watch(memberRemoteDataSourceProvider));
});

final getMyProfileProvider = Provider<GetMyProfile>((ref) {
  return GetMyProfile(ref.watch(memberRepositoryProvider));
});

final updateMyProfileUseCaseProvider = Provider<UpdateMyProfile>((ref) {
  return UpdateMyProfile(ref.watch(memberRepositoryProvider));
});

final myProfileProvider = FutureProvider<MemberProfile>((ref) async {
  final authState = await ref.watch(authProvider.future);
  final memberId = authState.memberId;

  if (!authState.isLoggedIn || memberId == null) {
    throw const ApiException(
      'Your session is invalid or has expired.',
      type: ApiExceptionType.unauthorized,
      statusCode: 401,
    );
  }

  return ref.watch(getMyProfileProvider)(memberId);
});

class UpdateMyProfileNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> saveProfile({
    required String fullName,
    required String email,
    required String? phoneNumber,
  }) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    try {
      final authState = await ref.read(authProvider.future);
      final memberId = authState.memberId;

      if (!authState.isLoggedIn || memberId == null) {
        throw const ApiException(
          'Your session is invalid or has expired.',
          type: ApiExceptionType.unauthorized,
          statusCode: 401,
        );
      }

      await ref.read(updateMyProfileUseCaseProvider)(
        memberId: memberId,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
      );

      ref.invalidate(myProfileProvider);
      await ref.read(myProfileProvider.future);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final updateMyProfileProvider =
    AsyncNotifierProvider<UpdateMyProfileNotifier, void>(
      UpdateMyProfileNotifier.new,
    );
