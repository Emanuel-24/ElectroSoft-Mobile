import 'dart:convert';

class AuthResponse {
  final bool success;
  final AuthData data;

  AuthResponse({required this.success, required this.data});

  factory AuthResponse.fromJson(String str) =>
      AuthResponse.fromMap(json.decode(str));

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
    success: json["success"] ?? false,
    data: AuthData.fromMap(json["data"] ?? {}),
  );
}

class AuthData {
  final String token;
  final UserSession user;

  AuthData({required this.token, required this.user});

  factory AuthData.fromMap(Map<String, dynamic> json) => AuthData(
    token: json["token"] ?? "",
    user: UserSession.fromMap(json["user"] ?? {}),
  );
}

class UserSession {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final List<String> permissions;
  final bool isActive;
  final String documentNumber;

  UserSession({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.permissions,
    required this.isActive,
    required this.documentNumber,
  });

  factory UserSession.fromMap(Map<String, dynamic> json) => UserSession(
    id: json["id"] ?? "",
    fullName: json["fullName"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"] ?? "",
    role: json["role"] ?? "",
    permissions: List<String>.from(json["permissions"] ?? []),
    isActive: json["isActive"] ?? false,
    documentNumber: json["documentNumber"] ?? "",
  );
}
