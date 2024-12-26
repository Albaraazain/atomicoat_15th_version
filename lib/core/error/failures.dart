import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

// Machine specific failures
class MachineNotFoundFailure extends Failure {
  const MachineNotFoundFailure([String message = 'Machine not found']) : super(message: message);
}

class ComponentNotFoundFailure extends Failure {
  const ComponentNotFoundFailure([String message = 'Component not found']) : super(message: message);
}

class ParameterNotFoundFailure extends Failure {
  const ParameterNotFoundFailure([String message = 'Parameter not found']) : super(message: message);
}

class InvalidOperationFailure extends Failure {
  const InvalidOperationFailure([String message = 'Invalid operation']) : super(message: message);
}

class SafetyCheckFailure extends Failure {
  const SafetyCheckFailure([String message = 'Safety check failed']) : super(message: message);
}

class MaintenanceRequiredFailure extends Failure {
  const MaintenanceRequiredFailure([String message = 'Maintenance required']) : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error occurred']) : super(message: message);
}

class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message: message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred']) : super(message: message);
}