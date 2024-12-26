/// Exception thrown when a server error occurs
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error']);
}

/// Exception thrown when authentication fails
class AuthenticationException implements Exception {
  final String message;
  AuthenticationException([this.message = 'Authentication error']);
}

/// Exception thrown when there's a cache error
class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);
}

/// Exception thrown when network is not available
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error']);
}

/// Exception thrown when data validation fails
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

/// Exception thrown when safety issues are encountered
class SafetyException implements Exception {
  final String message;
  SafetyException(this.message);
}

/// Exception thrown when maintenance is required
class MaintenanceException implements Exception {
  final String message;
  MaintenanceException(this.message);
}

/// Exception thrown when user is not authorized
class UnauthorizedException implements Exception {
  final String? message;
  UnauthorizedException([this.message]);
}

/// Exception thrown when a resource is not found
class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Resource not found']);
}