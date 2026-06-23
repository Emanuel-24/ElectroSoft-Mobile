class DashboardStats {
  final double totalVentasMes;
  final double porcentajeCambioVentas;
  final int pedidosPendientes;
  final int pedidosUrgentes;
  final int stockCritico;

  const DashboardStats({
    required this.totalVentasMes,
    required this.porcentajeCambioVentas,
    required this.pedidosPendientes,
    required this.pedidosUrgentes,
    required this.stockCritico,
  });
}