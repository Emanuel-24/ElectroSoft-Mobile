class Category {
  final String id;
  final String name;
  final String description;
  final bool status;
  final int productsCount;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.productsCount,
  });
}