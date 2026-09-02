// --- Entidad Principal de Venta ---
class Sale {
  final String id;
  final String numeroFactura;
  final String clienteId;
  final String? clienteName; // firstName + lastName
  final String? clienteTipoDocumento;
  final String? clienteDocumento;
  final List<SaleProduct> productos;
  final double total;
  final String estado;
  final String? fechaVenta;
  final DateTime fechaCreacion;
  final InfoAnulacion? infoAnulacion;

  const Sale({
    required this.id,
    required this.numeroFactura,
    required this.clienteId,
    this.clienteName,
    this.clienteTipoDocumento,
    this.clienteDocumento,
    required this.productos,
    required this.total,
    required this.estado,
    this.fechaVenta,
    required this.fechaCreacion,
    this.infoAnulacion,
  });

  bool get isAnulada => estado.toUpperCase() == 'ANULADA';
}

class SaleProduct {
  final String productoId;
  final String? productName;
  final int quantity;
  final double precioUnitario;

  const SaleProduct({
    required this.productoId,
    this.productName,
    required this.quantity,
    required this.precioUnitario,
  });
}

class InfoAnulacion {
  final String? motivo;
  final DateTime? fechaAnulacion;

  const InfoAnulacion({
    this.motivo,
    this.fechaAnulacion,
  });
}
