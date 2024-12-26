import '../../domain/entities/auth_token.dart';

/// Data Transfer Object for AuthToken entity
class AuthTokenDTO {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthTokenDTO({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// Creates an AuthTokenDTO from JSON data
  factory AuthTokenDTO.fromJson(Map<String, dynamic> json) {
    return AuthTokenDTO(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  /// Converts AuthTokenDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  /// Converts AuthTokenDTO to domain AuthToken entity
  AuthToken toDomain() {
    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  /// Creates AuthTokenDTO from domain AuthToken entity
  factory AuthTokenDTO.fromDomain(AuthToken token) {
    return AuthTokenDTO(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      expiresAt: token.expiresAt,
    );
  }
}