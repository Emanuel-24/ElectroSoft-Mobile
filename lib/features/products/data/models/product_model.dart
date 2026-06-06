import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.categoryId,
    required super.categoryName,
    required super.price,
    required super.stock,
    required super.serial,
    required super.warranty,
    required super.status,
    required super.characteristics,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      categoryId: json['categoryId']?['_id'] ?? '',
      categoryName: json['categoryId']?['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      serial: json['serial'] ?? '',
      warranty: json['warranty'] ?? '',
      status: json['status'] ?? false,
      characteristics: (json['characteristics'] as List? ?? [])
          .map(
            (e) => Feature(
              name: e['name'] ?? '',
              unit: e['unit'] ?? '',
              value: e['value'] ?? '',
              visible: e['visible'] ?? true,
            ),
          )
          .toList(),
    );
  }
}