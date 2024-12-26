import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';
import '../value_objects/email.dart';

/// Repository interface for authentication operations
abstract class IAuthRepository {
  /// Attempts to sign in a user with email and password
  Future<Either<Failure, AuthToken>> signIn({
    required Email email,
    required String password,
  });

  /// Signs out the current user
  Future<Either<Failure, void>> signOut();

  /// Refreshes the authentication token
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken);

  /// Gets the currently authenticated user
  Future<Either<Failure, User>> getCurrentUser();

  /// Checks if a user is currently authenticated
  Future<bool> isAuthenticated();

  /// Gets the current authentication token if it exists
  Future<AuthToken?> getStoredToken();
}