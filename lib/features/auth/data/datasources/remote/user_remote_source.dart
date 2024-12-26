import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/user_dto.dart';

abstract class IUserRemoteSource {
  Future<UserDTO> register({
    required String name,
    required String email,
    required String password,
    required String machineSerialNumber,
  });

  Future<UserDTO> updateProfile({
    required String id,
    String? name,
    String? email,
  });

  Future<void> changePassword({
    required String id,
    required String currentPassword,
    required String newPassword,
  });

  Future<UserDTO> approveRegistration({
    required String userId,
    required String role,
  });

  Future<UserDTO> rejectRegistration({
    required String userId,
    required String reason,
  });

  Future<List<UserDTO>> getPendingRegistrations();

  Future<UserDTO> getUserById(String id);
  Future<UserDTO> getUserByEmail(String email);
}

/// Firebase implementation of the user remote data source
class UserRemoteSource implements IUserRemoteSource {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  UserRemoteSource({
    required FirebaseFirestore firestore,
    required firebase_auth.FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  @override
  Future<UserDTO> register({
    required String name,
    required String email,
    required String password,
    required String machineSerialNumber,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      // Create user document in Firestore
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'role': 'researcher',
        'machineSerialNumber': machineSerialNumber,
        'approvalStatus': 'pending',
        'lastLogin': DateTime.now().toIso8601String(),
      });

      return UserDTO(
        id: userId,
        name: name,
        email: email,
        machineSerialNumber: machineSerialNumber,
        approvalStatus: 'pending',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserDTO> updateProfile({
    required String id,
    String? name,
    String? email,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;

      await _firestore.collection('users').doc(id).update(updateData);

      final docSnapshot = await _firestore.collection('users').doc(id).get();
      final data = docSnapshot.data()!;

      return UserDTO(
        id: id,
        name: (data['name'] as String?) ?? '',
        email: (data['email'] as String?) ?? '',
        role: (data['role'] as String?) ?? 'researcher',
        machineSerialNumber: (data['machineSerialNumber'] as String?) ?? '',
        approvalStatus: (data['approvalStatus'] as String?) ?? 'pending',
        lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
        rejectionReason: data['rejectionReason'] as String?,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changePassword({
    required String id,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.uid != id) {
        throw UnauthorizedException('Not authorized to change password');
      }

      // Reauthenticate user before changing password
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Change password
      await user.updatePassword(newPassword);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserDTO> approveRegistration({
    required String userId,
    required String role,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': role,
        'approvalStatus': 'approved',
        'rejectionReason': null,
      });

      final docSnapshot = await _firestore.collection('users').doc(userId).get();
      final data = docSnapshot.data()!;

      return UserDTO(
        id: userId,
        name: (data['name'] as String?) ?? '',
        email: (data['email'] as String?) ?? '',
        role: role,
        machineSerialNumber: (data['machineSerialNumber'] as String?) ?? '',
        approvalStatus: 'approved',
        lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserDTO> rejectRegistration({
    required String userId,
    required String reason,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'approvalStatus': 'rejected',
        'rejectionReason': reason,
      });

      final docSnapshot = await _firestore.collection('users').doc(userId).get();
      final data = docSnapshot.data()!;

      return UserDTO(
        id: userId,
        name: (data['name'] as String?) ?? '',
        email: (data['email'] as String?) ?? '',
        role: (data['role'] as String?) ?? 'researcher',
        machineSerialNumber: (data['machineSerialNumber'] as String?) ?? '',
        approvalStatus: 'rejected',
        lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
        rejectionReason: reason,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserDTO>> getPendingRegistrations() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('approvalStatus', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserDTO(
          id: doc.id,
          name: (data['name'] as String?) ?? '',
          email: (data['email'] as String?) ?? '',
          role: (data['role'] as String?) ?? 'researcher',
          machineSerialNumber: (data['machineSerialNumber'] as String?) ?? '',
          approvalStatus: (data['approvalStatus'] as String?) ?? 'pending',
          lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
          rejectionReason: data['rejectionReason'] as String?,
        );
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserDTO> getUserById(String id) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(id).get();
      if (!docSnapshot.exists) {
        throw ValidationException('User not found');
      }

      final data = docSnapshot.data()!;
      return UserDTO(
        id: id,
        name: (data['name'] as String?) ?? '',
        email: (data['email'] as String?) ?? '',
        role: (data['role'] as String?) ?? 'researcher',
        machineSerialNumber: (data['machineSerialNumber'] as String?) ?? '',
        approvalStatus: (data['approvalStatus'] as String?) ?? 'pending',
        lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
        rejectionReason: data['rejectionReason'] as String?,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserDTO> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw ValidationException('User not found');
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();

      return UserDTO(
        id: doc.id,
        name: (data['name'] as String?) ?? '',
        email: (data['email'] as String?) ?? '',
        role: (data['role'] as String?) ?? 'researcher',
        machineSerialNumber: (data['machineSerialNumber'] as String?) ?? '',
        approvalStatus: (data['approvalStatus'] as String?) ?? 'pending',
        lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
        rejectionReason: data['rejectionReason'] as String?,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}