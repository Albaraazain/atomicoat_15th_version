import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_token.dart';
import '../repositories/i_auth_repository.dart';
import '../value_objects/email.dart';

/// Use case for signing in a user
class SignInUseCase implements UseCase<AuthToken, SignInParams> {
  final IAuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, AuthToken>> call(SignInParams params) {
    return repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for the sign in use case
class SignInParams extends Equatable {
  final Email email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}