import 'package:equatable/equatable.dart';
import '../value_objects/email.dart';
import '../value_objects/user_id.dart';

/// Represents a user in the system
class User extends Equatable {
  final UserId id;
  final String name;
  final Email email;
  final UserRole role;
  final DateTime? lastLogin;
  final String machineSerialNumber;
  final UserApprovalStatus approvalStatus;
  final String? rejectionReason;

  const User({
    required this.id,
    required this.name,
    required this.email,
    UserRole? role,
    this.lastLogin,
    required this.machineSerialNumber,
    this.approvalStatus = UserApprovalStatus.pending,
    this.rejectionReason,
  }) : role = role ?? UserRole.researcher;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        lastLogin,
        machineSerialNumber,
        approvalStatus,
        rejectionReason,
      ];

  User copyWith({
    UserId? id,
    String? name,
    Email? email,
    UserRole? role,
    DateTime? lastLogin,
    String? machineSerialNumber,
    UserApprovalStatus? approvalStatus,
    String? rejectionReason,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      lastLogin: lastLogin ?? this.lastLogin,
      machineSerialNumber: machineSerialNumber ?? this.machineSerialNumber,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

/// Defines the possible roles a user can have in the system
enum UserRole {
  admin,
  researcher,
  engineer,
}

/// Defines the possible approval statuses for a user
enum UserApprovalStatus {
  pending,
  approved,
  rejected,
}