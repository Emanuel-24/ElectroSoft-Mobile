class Order {
  final String id;
  final String documentNumber;
  final String clienteNombre;
  final double total;
  final String status; // "Pendiente" | "Anulado"
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

  bool get isPendiente => status == 'Pendiente';

  // Urgente = pendiente y vence en 3 días o menos
  bool get isUrgente {
    if (!isPendiente) return false;
    final diff = dueDate.difference(DateTime.now()).inDays;
    return diff <= 3;
  }
}