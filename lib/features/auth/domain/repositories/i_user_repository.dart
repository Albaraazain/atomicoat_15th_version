import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../value_objects/email.dart';
import '../value_objects/user_id.dart';

/// Repository interface for user management operations
abstract class IUserRepository {
  /// Registers a new user
  Future<Either<Failure, User>> register({
    required String name,
    required Email email,
    required String password,
    required String machineSerialNumber,
  });

  /// Updates user profile information
  Future<Either<Failure, User>> updateProfile({
    required UserId id,
    String? name,
    Email? email,
  });

  /// Changes user password
  Future<Either<Failure, void>> changePassword({
    required UserId id,
    required String currentPassword,
    required String newPassword,
  });

  /// Approves a user registration
  Future<Either<Failure, User>> approveRegistration({
    required UserId userId,
    required UserRole role,
  });

  /// Rejects a user registration
  Future<Either<Failure, User>> rejectRegistration({
    required UserId userId,
    required String reason,
  });

  /// Gets a user by their ID
  Future<Either<Failure, User>> getUserById(UserId id);

  /// Gets a user by their email
  Future<Either<Failure, User>> getUserByEmail(Email email);

  /// Gets all pending registration requests
  Future<Either<Failure, List<User>>> getPendingRegistrations();
}