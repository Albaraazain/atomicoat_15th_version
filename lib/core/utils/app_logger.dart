import 'package:logger/logger.dart';

/// A utility class for logging throughout the application
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Log an info message
  static void info(String message) {
    _logger.i(message);
  }

  /// Log an error message with optional error object and stack trace
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message
  static void warning(String message) {
    _logger.w(message);
  }

  /// Log a debug message
  static void debug(String message) {
    _logger.d(message);
  }

  /// Log a verbose message
  static void verbose(String message) {
    _logger.v(message);
  }
}