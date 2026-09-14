import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../../data/datasources/borrowing_remote_data_source.dart';
import '../../data/repositories/borrowing_repository_impl.dart';
import '../../domain/entities/borrowing.dart';
import '../../domain/repositories/borrowing_repository.dart';
import '../../domain/usecases/borrow_book.dart';
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

  if (!authState.isLoggedIn || memberId == null) {
    throw const ApiException(
      'Your session is invalid or has expired.',
      type: ApiExceptionType.unauthorized,
      statusCode: 401,
    );
  }

  return ref.watch(getMemberBorrowingsProvider)(memberId);
});

final borrowBookUseCaseProvider = Provider<BorrowBook>((ref) {
  return BorrowBook(ref.watch(borrowingRepositoryProvider));
});

class BorrowBookNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> borrowBook(int bookId) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authState = await ref.read(authProvider.future);
      final memberId = authState.memberId;

      if (!authState.isLoggedIn || memberId == null) {
        throw const ApiException(
          'Your session is invalid or has expired.',
          type: ApiExceptionType.unauthorized,
          statusCode: 401,
        );
      }

      final borrowBook = ref.read(borrowBookUseCaseProvider);
      await borrowBook(bookId: bookId, memberId: memberId);

      ref.invalidate(booksProvider);
      ref.invalidate(bookDetailsProvider(bookId));
      ref.invalidate(myBorrowingsProvider);
    });
  }
}

final borrowBookProvider = AsyncNotifierProvider<BorrowBookNotifier, void>(
  BorrowBookNotifier.new,
);
