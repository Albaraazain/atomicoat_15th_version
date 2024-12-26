import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/user_id.dart';
import '../datasources/remote/user_remote_source.dart';

/// Implementation of the user repository using Firebase
class UserRepositoryImpl implements IUserRepository {
  final IUserRemoteSource remoteSource;

  UserRepositoryImpl({
    required this.remoteSource,
  });

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required Email email,
    required String password,
    required String machineSerialNumber,
  }) async {
    try {
      final userDto = await remoteSource.register(
        name: name,
        email: email.toString(),
        password: password,
        machineSerialNumber: machineSerialNumber,
      );
      return Right(userDto.toDomain());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Not authorized to register'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message ?? 'Invalid registration data'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error during registration'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required UserId id,
    String? name,
    Email? email,
  }) async {
    try {
      final userDto = await remoteSource.updateProfile(
        id: id.toString(),
        name: name,
        email: email?.toString(),
      );
      return Right(userDto.toDomain());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Not authorized to update profile'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message ?? 'Invalid profile data'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error during profile update'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required UserId id,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteSource.changePassword(
        id: id.toString(),
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Not authorized to change password'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message ?? 'Invalid password data'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error during password change'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> approveRegistration({
    required UserId userId,
    required UserRole role,
  }) async {
    try {
      final userDto = await remoteSource.approveRegistration(
        userId: userId.toString(),
        role: role.toString().split('.').last.toLowerCase(),
      );
      return Right(userDto.toDomain());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Not authorized to approve registration'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message ?? 'Invalid approval data'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error during registration approval'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> rejectRegistration({
    required UserId userId,
    required String reason,
  }) async {
    try {
      final userDto = await remoteSource.rejectRegistration(
        userId: userId.toString(),
        reason: reason,
      );
      return Right(userDto.toDomain());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Not authorized to reject registration'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message ?? 'Invalid rejection data'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error during registration rejection'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(UserId id) async {
    try {
      final userDto = await remoteSource.getUserById(id.toString());
      return Right(userDto.toDomain());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Not authorized to get user'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message ?? 'Invalid user ID'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error while getting user'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserByEmail(Email email) async {
    try {
      final userDto = await remoteSource.getUserByEmail(email.toString());
      return Right(userDto.toDomain());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Not authorized to get user'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message ?? 'Invalid email'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error while getting user'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getPendingRegistrations() async {
    try {
      final userDtos = await remoteSource.getPendingRegistrations();
      return Right(userDtos.map((dto) => dto.toDomain()).toList());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Not authorized to get pending registrations'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error while getting pending registrations'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}