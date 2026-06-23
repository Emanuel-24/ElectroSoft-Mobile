class Sale {
  final String id;
  final String numeroFactura;
  final String clienteNombre;
  final double total;
  final String estado; // "ACTIVA" | "ANULADA"
  final DateTime fechaVenta;
  final DateTime fechaCreacion;

  const Sale({
    required this.id,
    required this.numeroFactura,
    required this.clienteNombre,
    required this.total,
    required this.estado,
    required this.fechaVenta,
    required this.fechaCreacion,
  });

  bool get isActiva => estado == 'ACTIVA';
}