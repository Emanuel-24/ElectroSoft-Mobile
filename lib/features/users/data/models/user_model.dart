class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final DocumentTypeModel documentType;
  final String documentNumber;
  final RoleModel role;
  final bool isActive;
  final String avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.documentType,
    required this.documentNumber,
    required this.role,
    required this.isActive,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      documentType: DocumentTypeModel.fromJson(json['documentType'] ?? {}),
      documentNumber: json['documentNumber'] ?? '',
      role: RoleModel.fromJson(json['role'] ?? {}),
      isActive: json['isActive'] ?? false,
      avatar: json['avatar'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class DocumentTypeModel {
  final String id;
  final String name;
  final String abbreviation;

  DocumentTypeModel({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
    );
  }
}

class RoleModel {
  final String id;
  final String name;
  final List<String> permissions;
  final bool isActive;

  RoleModel({
    required this.id,
    required this.name,
    required this.permissions,
    required this.isActive,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      permissions: List<String>.from(json['permissions'] ?? []),
      isActive: json['isActive'] ?? false,
    );
  }
}
