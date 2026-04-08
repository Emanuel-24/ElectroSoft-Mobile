class Rol {
  final String title;
  final String description;
  final String time;
  final bool isActive;

  const Rol({
    required this.title,
    required this.description,
    required this.time,
    this.isActive = true,
  });
}