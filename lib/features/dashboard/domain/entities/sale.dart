class Sale {
  final String id;
  final String numeroFactura;
  final String clienteNombre;
  final double total;
  final double montoPagado;
  final String tipoVenta;
  final String estado;
  final DateTime fechaVenta;
  final DateTime fechaCreacion;

  const Sale({
    required this.id,
    required this.numeroFactura,
    required this.clienteNombre,
    required this.total,
    required this.montoPagado,
    required this.tipoVenta,
    required this.estado,
    required this.fechaVenta,
    required this.fechaCreacion,
  });

  bool get isActiva {
    final normalizedState = estado.trim().toUpperCase();
    return normalizedState != 'ANULADA' && normalizedState != 'ANULADO';
  }

  double get montoCobrado => tipoVenta.trim().toLowerCase() == 'contado'
      ? total
      : montoPagado;
}