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
}
