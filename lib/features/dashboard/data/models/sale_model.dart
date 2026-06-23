import '../../domain/entities/sale.dart';

class SaleModel extends Sale {
  const SaleModel({
    required super.id,
    required super.numeroFactura,
    required super.clienteNombre,
    required super.total,
    required super.estado,
    required super.fechaVenta,
    required super.fechaCreacion,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    final cliente = json['clienteId'];

    return SaleModel(
      id: json['_id'] ?? '',
      numeroFactura: json['numeroFactura'] ?? '',
      clienteNombre: cliente != null
          ? '${cliente['firstName'] ?? ''} ${cliente['lastName'] ?? ''}'.trim()
          : 'Cliente',
      total: (json['total'] ?? 0).toDouble(),
      estado: json['estado'] ?? 'ACTIVA',
      fechaVenta: DateTime.tryParse(json['fechaVenta'] ?? '') ?? DateTime.now(),
      fechaCreacion:
          DateTime.tryParse(json['fechaCreacion'] ?? '') ?? DateTime.now(),
    );
  }
}