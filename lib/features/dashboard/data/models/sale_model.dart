import '../../domain/entities/sale.dart';

class SaleModel extends Sale {
  const SaleModel({
    required super.id,
    required super.numeroFactura,
    required super.clienteNombre,
    required super.total,
    required super.montoPagado,
    required super.tipoVenta,
    required super.estado,
    required super.fechaVenta,
    required super.fechaCreacion,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    final cliente = json['clienteId'];
    final fechaCreacion = _parseDate(json['fechaCreacion']) ?? DateTime.now();

    return SaleModel(
      id: json['_id']?.toString() ?? '',
      numeroFactura: json['numeroFactura']?.toString() ?? '',
      clienteNombre: cliente != null
          ? '${cliente['firstName'] ?? ''} ${cliente['lastName'] ?? ''}'.trim()
          : 'Cliente',
      total: _parseAmount(json['total']),
      montoPagado: _parseAmount(json['montoPagado']),
      tipoVenta: json['tipoVenta']?.toString() ?? 'Contado',
      estado: json['estado']?.toString() ?? 'Vigente',
      fechaVenta: _parseDate(json['fechaVenta']) ?? fechaCreacion,
      fechaCreacion: fechaCreacion,
    );
  }

  static double _parseAmount(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) return null;

    final isoDate = DateTime.tryParse(text);
    if (isoDate != null) return isoDate;

    final parts = text.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }
}