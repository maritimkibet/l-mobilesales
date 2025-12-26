/// @widget: User Model
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: User data model

class UserModel {
  final String id;
  final String username;
  final String employeeId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final String department;
  final List<String> permissions;
  final double approvalLimit;
  final String region;
  final String status;

  UserModel({
    required this.id,
    required this.username,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.permissions,
    required this.approvalLimit,
    required this.region,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      employeeId: json['employee_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      department: json['department'] ?? '',
      permissions: List<String>.from(json['permissions'] ?? []),
      approvalLimit: (json['approval_limit'] ?? 0).toDouble(),
      region: json['region'] ?? '',
      status: json['status'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}
