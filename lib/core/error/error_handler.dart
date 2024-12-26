import 'failures.dart';

class ErrorHandler {
  static Failure handleError(dynamic error) {
    // Add specific error handling logic here
    if (error is ServerFailure) {
      return error;
    } else if (error is NetworkFailure) {
      return error;
    } else if (error is CacheFailure) {
      return error;
    } else {
      return const ServerFailure(message: 'An unexpected error occurred');
    }
  }

  static String getErrorMessage(Failure failure) {
    return failure.message;
  }
}