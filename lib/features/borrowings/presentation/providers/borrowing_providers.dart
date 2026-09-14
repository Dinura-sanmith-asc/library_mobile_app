import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/borrowing_remote_data_source.dart';
import '../../data/repositories/borrowing_repository_impl.dart';
import '../../domain/entities/borrowing.dart';
import '../../domain/repositories/borrowing_repository.dart';
import '../../domain/usecases/get_member_borrowings.dart';

final borrowingRemoteDataSourceProvider = Provider<BorrowingRemoteDataSource>((
  ref,
) {
  return BorrowingRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final borrowingRepositoryProvider = Provider<BorrowingRepository>((ref) {
  return BorrowingRepositoryImpl(ref.watch(borrowingRemoteDataSourceProvider));
});

final getMemberBorrowingsProvider = Provider<GetMemberBorrowings>((ref) {
  return GetMemberBorrowings(ref.watch(borrowingRepositoryProvider));
});

final myBorrowingsProvider = FutureProvider<List<Borrowing>>((ref) async {
  final authState = await ref.watch(authProvider.future);
  final memberId = authState.memberId;

  if (memberId == null) {
    throw StateError('No authenticated member session was found.');
  }

  return ref.watch(getMemberBorrowingsProvider)(memberId);
});
