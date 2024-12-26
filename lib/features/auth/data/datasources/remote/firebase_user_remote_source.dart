import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_remote_source.dart';
import '../../models/user_dto.dart';

class FirebaseUserRemoteSource implements IUserRemoteSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseUserRemoteSource({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserDTO> register({
    required String email,
    required String password,
    required String name,
    required String machineSerialNumber,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = UserDTO(
      id: userCredential.user!.uid,
      email: email,
      name: name,
      machineSerialNumber: machineSerialNumber,
      role: 'user',
      approvalStatus: 'pending',
    );

    await firestore.collection('users').doc(user.id).set(user.toJson());
    return user;
  }

  @override
  Future<UserDTO> getUserById(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    return UserDTO.fromJson(doc.data()!);
  }

  @override
  Future<UserDTO> getUserByEmail(String email) async {
    final snapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return UserDTO.fromJson(snapshot.docs.first.data());
  }

  @override
  Future<List<UserDTO>> getPendingRegistrations() async {
    final snapshot = await firestore
        .collection('users')
        .where('approvalStatus', isEqualTo: 'pending')
        .get();

    return snapshot.docs
        .map((doc) => UserDTO.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<UserDTO> approveRegistration({
    required String userId,
    required String role,
  }) async {
    await firestore.collection('users').doc(userId).update({
      'approvalStatus': 'approved',
      'role': role,
    });
    return getUserById(userId);
  }

  @override
  Future<UserDTO> rejectRegistration({
    required String userId,
    required String reason,
  }) async {
    await firestore.collection('users').doc(userId).update({
      'approvalStatus': 'rejected',
      'rejectionReason': reason,
    });
    return getUserById(userId);
  }

  @override
  Future<void> changePassword({
    required String id,
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  @override
  Future<UserDTO> updateProfile({
    required String id,
    String? name,
    String? email,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (email != null) updates['email'] = email;

    if (updates.isNotEmpty) {
      await firestore.collection('users').doc(id).update(updates);
    }

    return getUserById(id);
  }
}