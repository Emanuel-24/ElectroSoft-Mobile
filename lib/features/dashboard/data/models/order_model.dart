import '../../domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.documentNumber,
    required super.clienteNombre,
    required super.total,
    required super.status,
    required super.orderDate,
    required super.dueDate,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final cliente = json['client'];

    return OrderModel(
      id: json['_id'] ?? '',
      documentNumber: json['documentNumber'] ?? '',
      clienteNombre: cliente != null
          ? '${cliente['firstName'] ?? ''} ${cliente['lastName'] ?? ''}'.trim()
          : 'Cliente',
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'Por procesar',
      orderDate: DateTime.tryParse(json['orderDate'] ?? '') ?? DateTime.now(),
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}