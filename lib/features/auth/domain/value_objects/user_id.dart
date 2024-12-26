import 'package:equatable/equatable.dart';

/// Value object representing a unique user identifier
class UserId extends Equatable {
  final String value;

  const UserId._(this.value);

  /// Creates a new [UserId] instance if the provided value is valid
  static UserId? create(String? id) {
    if (id == null || id.isEmpty) return null;
    return UserId._(id);
  }

  @override
  List<Object> get props => [value];

  @override
  String toString() => value;
}