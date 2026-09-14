import '../entities/borrowing.dart';
import '../repositories/borrowing_repository.dart';

class GetMemberBorrowings {
  final BorrowingRepository repository;

  const GetMemberBorrowings(this.repository);

  Future<List<Borrowing>> call(int memberId) {
    return repository.getMemberBorrowings(memberId);
  }
}
