// PANTALLA PRINCIPAL DEL DASHBOARD
import 'package:electrosoft/features/dashboard/presentation/widgets/sales_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/stats_card.dart';
import '../widgets/activity_item.dart';
import '../screens/notifications_screen.dart';
import '../../../products/data/services/product_service.dart';
import '../../data/services/order_service.dart';
import '../../data/services/sale_service.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProductService _productService = ProductService();
  final OrderService _orderService = OrderService();
  final SaleService _saleService = SaleService();

  Map<int, double> _ventasPorMes = {};

  int _numCriticos = 0;
  int _pedidosPendientes = 0;
  int _pedidosUrgentes = 0;
  double _ventasTotales = 0;

  bool _loadingVentas = true;
  bool _isLoadingStock = true;

  @override
  void initState() {
    super.initState();

    _calcularStockCritico();
    _cargarPedidosPendientes();
    _cargarVentas();
  }

  Future<void> _calcularStockCritico() async {
    try {
      final productos = await _productService.obtenerProductos();
      if (mounted) {
        setState(() {
          _numCriticos = productos.where((p) => p.stock <= 10).length;
          _isLoadingStock = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingStock = false);
      }
    }
  }

  Future<void> _cargarPedidosPendientes() async {
    try {
      final pedidos = await _orderService.obtenerPedidos();

      if (mounted) {
        setState(() {
          _pedidosPendientes = pedidos.where((p) => p.isPendiente).length;

          _pedidosUrgentes = pedidos.where((p) => p.isUrgente).length;
        });
      }
    } catch (e) {
      debugPrint('Error cargando pedidos: $e');
    }
  }

  Future<void> _cargarVentas() async {
    try {
      final ventas = await _saleService.obtenerVentas();

      final Map<int, double> ventasPorMes = {};

      double total = 0;

      for (final venta in ventas) {
        if (venta.estado != 'ACTIVA') continue;

        total += venta.total;

        final mes = venta.fechaVenta.month;

        ventasPorMes[mes] = (ventasPorMes[mes] ?? 0) + venta.total;
      }

      if (mounted) {
        setState(() {
          _ventasPorMes = ventasPorMes;
          _ventasTotales = total;
          _loadingVentas = false;
        });
      }
    } catch (e) {
      debugPrint('Error cargando ventas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Bienvenido de nuevo,',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  _NotificationBadge(),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VENTAS TOTALES',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _loadingVentas
                              ? '...'
                              : NumberFormat.currency(
                                  symbol: '\$',
                                  decimalDigits: 0,
                                  locale: 'es_CO',
                                ).format(_ventasTotales),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 300,
                          child: _loadingVentas
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFFFCC00),
                                  ),
                                )
                              : SalesChart(ventasPorMes: _ventasPorMes),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          title: 'Pedidos Pendientes',
                          value: '$_pedidosPendientes',
                          subtitle: '$_pedidosUrgentes urgentes',
                          icon: Icons.shopping_cart_outlined,
                          accentColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatsCard(
                          title: 'Stock Crítico',
                          value: _isLoadingStock ? '...' : '$_numCriticos',
                          subtitle: _numCriticos > 0
                              ? 'Requiere atención'
                              : 'Todo en orden',
                          icon: Icons.inventory_2_outlined,
                          accentColor: _numCriticos > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Actividad Reciente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Ver todo',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),

                  const ActivityItem(
                    title: 'Nuevo pedido #10234',
                    subtitle: 'Cliente: Juan Pérez',
                    time: 'Hace 10m',
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.green,
                  ),
                  const ActivityItem(
                    title: 'Usuario registrado',
                    subtitle: 'Rol: Cliente',
                    time: 'Hace 45m',
                    icon: Icons.person_add_outlined,
                    iconColor: Colors.blue,
                  ),
                  const ActivityItem(
                    title: 'Nuevo pedido #10235',
                    subtitle: 'Cliente: Juan Santa',
                    time: 'Hace 1h',
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black87,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}