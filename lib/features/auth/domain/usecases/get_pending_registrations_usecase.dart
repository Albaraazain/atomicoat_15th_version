import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/i_user_repository.dart';

/// Use case for getting all pending user registrations
class GetPendingRegistrationsUseCase implements UseCase<List<User>, NoParams> {
  final IUserRepository repository;

  GetPendingRegistrationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) {
    return repository.getPendingRegistrations();
  }
}