class Usuario {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String documentNumber;
  final String roleName;
  final String documentAbbreviation;
  final bool isActive;
  final String lastAccess;

  const Usuario({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.documentNumber,
    required this.roleName,
    required this.documentAbbreviation,
    required this.isActive,
    required this.lastAccess,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    final roleObj = json['role'] ?? {};
    final docTypeObj = json['documentType'] ?? {};

    String formattedDate = 'No access';
    if (json['updatedAt'] != null) {
      final DateTime date = DateTime.parse(json['updatedAt']);
      formattedDate = "${date.day}/${date.month}/${date.year}";
    }

    return Usuario(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      documentNumber: json['documentNumber'] ?? '',
      roleName: roleObj['name'] ?? 'No Role',
      documentAbbreviation: docTypeObj['abbreviation'] ?? 'CC',
      isActive: json['isActive'] ?? false,
      lastAccess: formattedDate,
    );
  }
}