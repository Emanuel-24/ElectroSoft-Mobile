class Product {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final double price;
  final int stock;
  final String serial;
  final String warranty;
  final bool status;
  final List<Feature> characteristics;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.stock,
    required this.serial,
    required this.warranty,
    required this.status,
    required this.characteristics,
  });
}

class Feature {
  final String name;
  final String unit;
  final String value;
  final bool visible;

  const Feature({
    required this.name,
    required this.unit,
    required this.value,
    required this.visible,
  });
}