class Usuario {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String documentNumber;
  final String documentTypeId;
  final String roleName;
  final String documentAbbreviation;
  final bool isActive;
  final String lastAccess;
  final String avatar;
  final String avatarLetter;
  final String avatarColor;

  const Usuario({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.documentNumber,
    this.documentTypeId = '',
    required this.roleName,
    required this.documentAbbreviation,
    required this.isActive,
    required this.lastAccess,
    this.avatar = '',
    this.avatarLetter = 'A',
    this.avatarColor = '#273bf1',
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
      documentTypeId: docTypeObj['_id'] ?? '',
      roleName: roleObj['name'] ?? 'No Role',
      documentAbbreviation: docTypeObj['abbreviation'] ?? 'CC',
      isActive: json['isActive'] ?? false,
      lastAccess: formattedDate,
      avatar: json['avatar'] ?? '',
      avatarLetter: json['avatarLetter'] ?? 'A',
      avatarColor: json['avatarColor'] ?? '#273bf1',
    );
  }
}
