import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/user_id.dart';

part 'user_dto.g.dart';

@HiveType(typeId: 1)
class UserDTO {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String role;
  @HiveField(4)
  final DateTime? lastLogin;
  @HiveField(5)
  final String machineSerialNumber;
  @HiveField(6)
  final String approvalStatus;
  @HiveField(7)
  final String? rejectionReason;

  const UserDTO({
    required this.id,
    required this.name,
    required this.email,
    String? role,
    this.lastLogin,
    required this.machineSerialNumber,
    required this.approvalStatus,
    this.rejectionReason,
  }) : role = role ?? 'researcher';

  /// Creates a UserDTO from JSON data
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String?,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      machineSerialNumber: json['machineSerialNumber'] as String,
      approvalStatus: json['approvalStatus'] as String,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  /// Converts UserDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'lastLogin': lastLogin?.toIso8601String(),
      'machineSerialNumber': machineSerialNumber,
      'approvalStatus': approvalStatus,
      'rejectionReason': rejectionReason,
    };
  }

  /// Converts UserDTO to domain User entity
  User toDomain() {
    final userId = UserId.create(id);
    final userEmail = Email.create(email);
    final userRole = UserRole.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == role.toLowerCase(),
      orElse: () => UserRole.researcher,
    );

    if (userId == null || userEmail == null) {
      throw Exception('Invalid user data');
    }

    return User(
      id: userId,
      name: name,
      email: userEmail,
      role: userRole,
      lastLogin: lastLogin,
      machineSerialNumber: machineSerialNumber,
      approvalStatus: UserApprovalStatus.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == approvalStatus.toLowerCase(),
        orElse: () => UserApprovalStatus.pending,
      ),
      rejectionReason: rejectionReason,
    );
  }

  /// Creates UserDTO from domain User entity
  factory UserDTO.fromDomain(User user) {
    return UserDTO(
      id: user.id.toString(),
      name: user.name,
      email: user.email.toString(),
      role: user.role.toString().split('.').last.toLowerCase(),
      lastLogin: user.lastLogin,
      machineSerialNumber: user.machineSerialNumber,
      approvalStatus: user.approvalStatus.toString().split('.').last.toLowerCase(),
      rejectionReason: user.rejectionReason,
    );
  }

  /// Creates a copy of this UserDTO with the given fields replaced with new values
  UserDTO copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    DateTime? lastLogin,
    String? machineSerialNumber,
    String? approvalStatus,
    String? rejectionReason,
  }) {
    return UserDTO(
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