class ClientModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DocumentTypeModel documentType;
  final String documentNumber;
  final bool estado;
  final double cupoTotal;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.documentType,
    required this.documentNumber,
    required this.estado,
    required this.cupoTotal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      documentType: DocumentTypeModel.fromJson(json['documentType'] ?? {}),
      documentNumber: json['documentNumber'] ?? '',
      estado: json['estado'] ?? true,
      cupoTotal: (json['cupoTotal'] ?? 0).toDouble(),
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
