import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/i_user_repository.dart';
import '../value_objects/user_id.dart';

/// Use case for approving a user's registration
class ApproveUserRegistrationUseCase implements UseCase<User, ApproveUserRegistrationParams> {
  final IUserRepository repository;

  ApproveUserRegistrationUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(ApproveUserRegistrationParams params) {
    return repository.approveRegistration(
      userId: params.userId,
      role: params.assignedRole,
    );
  }
}

/// Parameters for approving a user registration
class ApproveUserRegistrationParams extends Equatable {
  final UserId userId;
  final UserRole assignedRole;

  const ApproveUserRegistrationParams({
    required this.userId,
    required this.assignedRole,
  });

  @override
  List<Object> get props => [userId, assignedRole];
}