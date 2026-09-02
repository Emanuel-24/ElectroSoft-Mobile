class Cliente {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String documentNumber;
  final String documentType;
  final String documentAbbreviation;
  final bool estado;
  final double cupoTotal;
  final String avatarLetter;
  final String avatarColor;

  const Cliente({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.documentNumber,
    required this.documentType,
    required this.documentAbbreviation,
    required this.estado,
    required this.cupoTotal,
    this.avatarLetter = 'A',
    this.avatarColor = '#273bf1',
  });

  // Nombre completo
  String get fullName => '$firstName $lastName';

  factory Cliente.fromJson(Map<String, dynamic> json) {
    final docTypeObj = json['documentType'] ?? {};

    String docType = 'Unknown';
    String docAbbr = 'CC';

    if (docTypeObj is Map) {
      docType = docTypeObj['name'] ?? 'Unknown';
      docAbbr = docTypeObj['abbreviation'] ?? 'CC';
    } else if (docTypeObj is String) {
      docType = docTypeObj;
    }

    // Generar letra avatar de firstName
    final letter = (json['firstName'] as String?)?.isNotEmpty == true
        ? (json['firstName'] as String).substring(0, 1).toUpperCase()
        : 'A';

    return Cliente(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      documentNumber: json['documentNumber'] ?? '',
      documentType: docType,
      documentAbbreviation: docAbbr,
      estado: json['estado'] ?? true,
      cupoTotal: (json['cupoTotal'] ?? 0).toDouble(),
      avatarLetter: letter,
      avatarColor: '#273bf1',
    );
  }
}
