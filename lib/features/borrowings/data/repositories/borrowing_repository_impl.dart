import '../../domain/entities/borrowing.dart';
import '../../domain/repositories/borrowing_repository.dart';
import '../datasources/borrowing_remote_data_source.dart';

class BorrowingRepositoryImpl implements BorrowingRepository {
  final BorrowingRemoteDataSource remoteDataSource;

  const BorrowingRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Borrowing>> getMemberBorrowings(int memberId) async {
    final models = await remoteDataSource.getMemberBorrowings(memberId);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> borrowBook({required int bookId, required int memberId}) {
    return remoteDataSource.borrowBook(bookId: bookId, memberId: memberId);
  }

  @override
  Future<void> returnBook(int borrowingId) {
    return remoteDataSource.returnBook(borrowingId);
  }
}
