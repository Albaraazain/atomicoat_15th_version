import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/auth_token_dto.dart';
import '../../models/user_dto.dart';

abstract class IAuthRemoteSource {
  Future<AuthTokenDTO> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<AuthTokenDTO> refreshToken();
  Future<UserDTO> getCurrentUser();
  Future<void> createAdminUser(String email, String password);
}

/// Remote data source for authentication operations using Firebase
class FirebaseAuthRemoteSource implements IAuthRemoteSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRemoteSource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<AuthTokenDTO> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Attempting to sign in with email: $email');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('🔐 Firebase auth response: ${userCredential.toString()}');

      if (userCredential.user == null) {
        print('❌ Failed to get user after sign in');
        throw UnauthorizedException('Failed to get user');
      }

      print('🔐 Getting ID token for user: ${userCredential.user!.uid}');
      final token = await userCredential.user!.getIdToken();
      if (token == null) {
        print('❌ Failed to get token');
        throw UnauthorizedException('Failed to get token');
      }
      print('✅ Successfully got ID token');

      // Firebase tokens are valid for 1 hour
      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      // Get the refresh token or throw an exception if null
      print('🔐 Getting refresh token');
      final refreshToken = userCredential.user!.refreshToken ?? '';
      print('✅ Got refresh token (empty string if not available)');

      final authToken = AuthTokenDTO(
        accessToken: token,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
      );
      print('✅ Successfully created AuthTokenDTO');

      // Update last login time in Firestore
      try {
        await _updateLastLogin(userCredential.user!.uid);
        print('✅ Updated last login time');
      } catch (e) {
        print('⚠️ Failed to update last login time: $e');
        // Don't throw here as this is not critical
      }

      return authToken;
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          throw UnauthorizedException('Invalid email or password');
        case 'invalid-email':
          throw ValidationException('Invalid email format');
        case 'user-disabled':
          throw UnauthorizedException('Account has been disabled');
        default:
          throw ServerException(e.message ?? 'An unknown error occurred');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthTokenDTO> refreshToken() async {
    try {
      print('🔄 Attempting to refresh token');
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        print('❌ No authenticated user found');
        throw UnauthorizedException('No authenticated user');
      }

      print('🔄 Getting new ID token');
      final token = await user.getIdToken(true); // Force token refresh
      if (token == null) {
        print('❌ Failed to get new token');
        throw UnauthorizedException('Failed to get token');
      }
      print('✅ Successfully got new ID token');

      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      print('🔄 Getting refresh token');
      final refreshToken = user.refreshToken ?? '';
      print('✅ Got refresh token (empty string if not available)');

      return AuthTokenDTO(
        accessToken: token,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
      );
    } catch (e) {
      print('❌ Error refreshing token: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserDTO> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw UnauthorizedException('No authenticated user');

      // Get additional user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw ServerException('User data not found in Firestore');
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      return UserDTO(
        id: user.uid,
        name: userData['name'] ?? '',
        email: user.email!,
        role: userData['role'],
        lastLogin: userData['lastLogin'] != null
            ? (userData['lastLogin'] as Timestamp).toDate()
            : null,
        machineSerialNumber: userData['machineSerialNumber'] ?? '',
        approvalStatus: userData['approvalStatus'] ?? 'pending',
        rejectionReason: userData['rejectionReason'],
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Helper method to update user's last login
  Future<void> _updateLastLogin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Don't throw here, just log the error as this is not critical
      print('Failed to update last login: $e');
    }
  }

  // DEVELOPMENT ONLY - Create admin user
  @override
  Future<void> createAdminUser(String email, String password) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set up admin data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': 'Admin User',
        'email': email,
        'role': 'admin',
        'approvalStatus': 'approved',
        'machineSerialNumber': 'ADMIN-000',
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}