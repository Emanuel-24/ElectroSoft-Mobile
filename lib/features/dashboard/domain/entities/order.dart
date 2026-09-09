class Order {
  final String id;
  final String documentNumber;
  final String clienteNombre;
  final double total;
  final String status; // "Por procesar" | "Anulado"
  final DateTime orderDate;
  final DateTime dueDate;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.documentNumber,
    required this.clienteNombre,
    required this.total,
    required this.status,
    required this.orderDate,
    required this.dueDate,
    required this.createdAt,
  });

  bool get isPorProcesar => status == 'Por procesar';

  // Urgente = por procesar y vence en menos de 24 horas.
  bool get isUrgente {
    if (!isPorProcesar) return false;

    final remaining = dueDate.difference(DateTime.now());
    return remaining > Duration.zero && remaining < const Duration(hours: 24);
  }
}