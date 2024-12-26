import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Represents the different states of authentication
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts
class AuthInitial extends AuthState {}

/// State when authentication is in progress
class AuthLoading extends AuthState {}

/// State when user is authenticated
class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

/// State when user is awaiting approval
class PendingApproval extends AuthState {
  final User user;

  const PendingApproval(this.user);

  @override
  List<Object> get props => [user];
}

/// State when user's registration was rejected
class RegistrationRejected extends AuthState {
  final User user;
  final String reason;

  const RegistrationRejected(this.user, this.reason);

  @override
  List<Object> get props => [user, reason];
}

/// State when pending registrations are loaded
class PendingRegistrationsLoaded extends AuthState {
  final List<User> pendingUsers;

  const PendingRegistrationsLoaded(this.pendingUsers);

  @override
  List<Object> get props => [pendingUsers];
}

/// State when user is not authenticated
class Unauthenticated extends AuthState {}

/// State when authentication fails
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}