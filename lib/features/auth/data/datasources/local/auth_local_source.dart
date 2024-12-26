import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/error/exceptions.dart';
import '../../models/auth_token_dto.dart';
import '../../models/user_dto.dart';

abstract class IAuthLocalSource {
  Future<void> cacheAuthToken(AuthTokenDTO token);
  Future<void> cacheUser(UserDTO user);
  Future<AuthTokenDTO?> getLastAuthToken();
  Future<UserDTO?> getLastUser();
  Future<void> clearAuth();
}

/// Local data source for authentication
/// Handles caching of auth tokens and user data
class AuthLocalSource implements IAuthLocalSource {
  final SharedPreferences sharedPreferences;
  static const String authTokenKey = 'CACHED_AUTH_TOKEN';
  static const String userKey = 'CACHED_USER';

  AuthLocalSource({required this.sharedPreferences});

  @override
  Future<void> cacheAuthToken(AuthTokenDTO token) async {
    try {
      await sharedPreferences.setString(
        authTokenKey,
        json.encode(token.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache auth token');
    }
  }

  @override
  Future<void> cacheUser(UserDTO user) async {
    try {
      await sharedPreferences.setString(
        userKey,
        json.encode(user.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache user data');
    }
  }

  @override
  Future<AuthTokenDTO?> getLastAuthToken() async {
    try {
      final jsonString = sharedPreferences.getString(authTokenKey);
      if (jsonString == null) return null;

      return AuthTokenDTO.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    } catch (e) {
      throw CacheException('Failed to retrieve cached auth token');
    }
  }

  @override
  Future<UserDTO?> getLastUser() async {
    try {
      final jsonString = sharedPreferences.getString(userKey);
      if (jsonString == null) return null;

      return UserDTO.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    } catch (e) {
      throw CacheException('Failed to retrieve cached user data');
    }
  }

  @override
  Future<void> clearAuth() async {
    try {
      await Future.wait([
        sharedPreferences.remove(authTokenKey),
        sharedPreferences.remove(userKey),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear cached auth data');
    }
  }
}