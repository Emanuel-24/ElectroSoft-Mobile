class DocumentTypeEntity {
  final String id;
  final String name;
  final String abbreviation;

  DocumentTypeEntity({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory DocumentTypeEntity.fromJson(Map<String, dynamic> json) {
    return DocumentTypeEntity(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
    );
  }
}