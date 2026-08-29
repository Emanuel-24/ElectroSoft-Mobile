import '../../domain/entities/category.dart';

class CategoriaModel extends Category {
  const CategoriaModel({
    required super.id,
    required super.name,
    required super.description,
    required super.status,
    required super.productsCount,
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? false,
      productsCount: json['productsCount'] ?? 0,
    );
  }
}