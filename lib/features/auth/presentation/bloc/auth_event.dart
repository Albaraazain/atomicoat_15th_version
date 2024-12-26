import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check the current authentication status
class CheckAuthStatus extends AuthEvent {}

/// Event to sign in a user
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Event to register a new user
class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String machineSerialNumber;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.machineSerialNumber,
  });

  @override
  List<Object> get props => [name, email, password, machineSerialNumber];
}

/// Event to approve a user's registration
class ApproveRegistration extends AuthEvent {
  final String userId;
  final UserRole assignedRole;

  const ApproveRegistration({
    required this.userId,
    required this.assignedRole,
  });

  @override
  List<Object> get props => [userId, assignedRole];
}

/// Event to reject a user's registration
class RejectRegistration extends AuthEvent {
  final String userId;
  final String reason;

  const RejectRegistration({
    required this.userId,
    required this.reason,
  });

  @override
  List<Object> get props => [userId, reason];
}

/// Event to load pending registrations
class LoadPendingRegistrations extends AuthEvent {}

/// Event to sign out the current user
class SignOutRequested extends AuthEvent {}

/// Event when user data is updated
class UserUpdated extends AuthEvent {
  final String userId;

  const UserUpdated(this.userId);

  @override
  List<Object> get props => [userId];
}