import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/i_user_repository.dart';
import '../value_objects/email.dart';

/// Use case for registering a new user
class RegisterUserUseCase implements UseCase<User, RegisterUserParams> {
  final IUserRepository repository;

  RegisterUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterUserParams params) {
    return repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      machineSerialNumber: params.machineSerialNumber,
    );
  }
}

/// Parameters for the register user use case
class RegisterUserParams extends Equatable {
  final String name;
  final Email email;
  final String password;
  final String machineSerialNumber;

  const RegisterUserParams({
    required this.name,
    required this.email,
    required this.password,
    required this.machineSerialNumber,
  });

  @override
  List<Object> get props => [name, email, password, machineSerialNumber];
}