import '../../domain/repositories/borrowing_repository.dart';
import '../datasources/borrowing_remote_data_source.dart';

class BorrowingRepositoryImpl implements BorrowingRepository {
  final BorrowingRemoteDataSource remoteDataSource;

  const BorrowingRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> borrowBook({required int bookId, required int memberId}) {
    return remoteDataSource.borrowBook(bookId: bookId, memberId: memberId);
  }
}
