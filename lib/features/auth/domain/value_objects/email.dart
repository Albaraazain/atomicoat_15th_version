import 'package:equatable/equatable.dart';

/// Value object representing a validated email address
class Email extends Equatable {
  final String value;

  const Email._(this.value);

  /// Creates a new [Email] instance if the provided value is valid
  static Email? create(String? email) {
    if (email == null || email.isEmpty) return null;
    if (!_isValidEmail(email)) return null;
    return Email._(email);
  }

  /// Validates email format using regex
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  List<Object> get props => [value];

  @override
  String toString() => value;
}