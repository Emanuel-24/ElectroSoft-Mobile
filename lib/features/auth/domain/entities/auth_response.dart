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
  final String avatar;
  final String avatarLetter;
  final String avatarColor;

  UserSession({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.permissions,
    required this.isActive,
    required this.documentNumber,
    this.avatar = '',
    this.avatarLetter = 'A',
    this.avatarColor = '#273bf1',
  });

  factory UserSession.fromMap(Map<String, dynamic> json) {
    final dynamic rawRole = json["role"] ?? "";
    final String roleName = rawRole is Map<String, dynamic>
        ? (rawRole["name"] ?? rawRole["roleName"] ?? "")
        : rawRole.toString();

    return UserSession(
      id: json["id"] ?? "",
      fullName: json["fullName"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      role: roleName,
      permissions: List<String>.from(json["permissions"] ?? []),
      isActive: json["isActive"] ?? false,
      documentNumber: json["documentNumber"] ?? "",
      avatar: json["avatar"] ?? "",
      avatarLetter: json["avatarLetter"] ?? "A",
      avatarColor: json["avatarColor"] ?? "#273bf1",
    );
  }
}
