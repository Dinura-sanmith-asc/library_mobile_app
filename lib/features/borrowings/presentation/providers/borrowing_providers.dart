import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../../data/datasources/borrowing_remote_data_source.dart';
import '../../data/repositories/borrowing_repository_impl.dart';
import '../../domain/repositories/borrowing_repository.dart';
import '../../domain/usecases/borrow_book.dart';

final borrowingRemoteDataSourceProvider = Provider<BorrowingRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);

  return BorrowingRemoteDataSourceImpl(apiClient);
});

final borrowingRepositoryProvider = Provider<BorrowingRepository>((ref) {
  final remoteDataSource = ref.watch(borrowingRemoteDataSourceProvider);

  return BorrowingRepositoryImpl(remoteDataSource);
});

final borrowBookUseCaseProvider = Provider<BorrowBook>((ref) {
  final repository = ref.watch(borrowingRepositoryProvider);

  return BorrowBook(repository);
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
    });
  }
}

final borrowBookProvider = AsyncNotifierProvider<BorrowBookNotifier, void>(
  BorrowBookNotifier.new,
);
