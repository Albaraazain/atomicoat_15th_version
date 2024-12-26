import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/i_user_repository.dart';
import '../value_objects/user_id.dart';

/// Use case for rejecting a user's registration
class RejectUserRegistrationUseCase implements UseCase<User, RejectUserRegistrationParams> {
  final IUserRepository repository;

  RejectUserRegistrationUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RejectUserRegistrationParams params) {
    return repository.rejectRegistration(
      userId: params.userId,
      reason: params.reason,
    );
  }
}

/// Parameters for rejecting a user registration
class RejectUserRegistrationParams extends Equatable {
  final UserId userId;
  final String reason;

  const RejectUserRegistrationParams({
    required this.userId,
    required this.reason,
  });

  @override
  List<Object> get props => [userId, reason];
}