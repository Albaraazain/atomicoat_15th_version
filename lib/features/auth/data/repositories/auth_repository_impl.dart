import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/value_objects/email.dart';
import '../datasources/local/auth_local_source.dart';
import '../datasources/remote/auth_remote_source.dart';

/// Implementation of the auth repository using Firebase
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteSource remoteSource;
  final IAuthLocalSource localSource;

  AuthRepositoryImpl({
    required this.remoteSource,
    required this.localSource,
  });

  @override
  Future<Either<Failure, AuthToken>> signIn({
    required Email email,
    required String password,
  }) async {
    print('🔄 Starting sign in process in repository');
    try {
      print('🔄 Calling remote source signIn');
      final token = await remoteSource.signIn(
        email: email.toString(),
        password: password,
      );
      print('✅ Successfully got token from remote source');

      print('🔄 Caching auth token');
      await localSource.cacheAuthToken(token);
      print('✅ Successfully cached auth token');

      return Right(token.toDomain());
    } on UnauthorizedException catch (e) {
      print('❌ Unauthorized: ${e.message}');
      return Left(AuthFailure(message: e.message ?? 'Invalid credentials'));
    } on ValidationException catch (e) {
      print('❌ Validation error: ${e.message}');
      return Left(ValidationFailure(e.message ?? 'Invalid input'));
    } on ServerException catch (e) {
      print('❌ Server error: ${e.message}');
      return Left(ServerFailure(message: e.message ?? 'Server error during sign in'));
    } catch (e) {
      print('❌ Unexpected error: $e');
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    print('🔄 Starting sign out process');
    try {
      print('🔄 Calling remote source signOut');
      await remoteSource.signOut();
      print('✅ Successfully signed out from remote source');

      print('🔄 Clearing local auth data');
      await localSource.clearAuth();
      print('✅ Successfully cleared local auth data');

      return const Right(null);
    } on ServerException catch (e) {
      print('❌ Server error during sign out: ${e.message}');
      return Left(ServerFailure(message: e.message ?? 'Server error during sign out'));
    } catch (e) {
      print('❌ Unexpected error during sign out: $e');
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken) async {
    print('🔄 Starting token refresh');
    try {
      print('🔄 Calling remote source refreshToken');
      final token = await remoteSource.refreshToken();
      print('✅ Successfully refreshed token');

      print('🔄 Caching new auth token');
      await localSource.cacheAuthToken(token);
      print('✅ Successfully cached new auth token');

      return Right(token.toDomain());
    } on UnauthorizedException catch (e) {
      print('❌ Unauthorized during token refresh: ${e.message}');
      return Left(AuthFailure(message: e.message ?? 'Invalid refresh token'));
    } on ServerException catch (e) {
      print('❌ Server error during token refresh: ${e.message}');
      return Left(ServerFailure(message: e.message ?? 'Server error during token refresh'));
    } catch (e) {
      print('❌ Unexpected error during token refresh: $e');
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    print('🔄 Getting current user');
    try {
      try {
        print('🔄 Fetching user from remote source');
        final userDto = await remoteSource.getCurrentUser();
        print('✅ Successfully got user from remote source');

        print('🔄 Caching user data');
        await localSource.cacheUser(userDto);
        print('✅ Successfully cached user data');

        return Right(userDto.toDomain());
      } catch (e) {
        print('⚠️ Failed to get user from remote source, trying cache');
        // If network request fails, try to get cached user
        final cachedUser = await localSource.getLastUser();
        if (cachedUser != null) {
          print('✅ Successfully retrieved user from cache');
          return Right(cachedUser.toDomain());
        }
        print('❌ No cached user found');
        rethrow;
      }
    } on UnauthorizedException catch (e) {
      print('❌ Unauthorized: ${e.message}');
      return Left(AuthFailure(message: e.message ?? 'No authenticated user'));
    } on ServerException catch (e) {
      print('❌ Server error: ${e.message}');
      return Left(ServerFailure(message: e.message ?? 'Error fetching user data'));
    } catch (e) {
      print('❌ Unexpected error: $e');
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    print('🔄 Checking authentication status');
    try {
      final token = await localSource.getLastAuthToken();
      if (token == null) {
        print('❌ No token found');
        return false;
      }
      final isValid = !token.expiresAt.isBefore(DateTime.now());
      print(isValid ? '✅ Token is valid' : '❌ Token is expired');
      return isValid;
    } catch (e) {
      print('❌ Error checking authentication status: $e');
      return false;
    }
  }

  @override
  Future<AuthToken?> getStoredToken() async {
    print('🔄 Getting stored token');
    try {
      final token = await localSource.getLastAuthToken();
      print(token != null ? '✅ Found stored token' : '❌ No stored token found');
      return token?.toDomain();
    } catch (e) {
      print('❌ Error getting stored token: $e');
      return null;
    }
  }
}