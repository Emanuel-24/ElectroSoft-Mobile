// PANTALLA PRINCIPAL DEL DASHBOARD
import 'package:electrosoft/features/dashboard/presentation/widgets/sales_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/stats_card.dart';
import '../widgets/activity_item.dart';
import '../screens/notifications_screen.dart';
import '../../../products/data/services/product_service.dart';
import '../../../products/domain/entities/product.dart';
import 'critical_stock_screen.dart';
import '../../data/services/order_service.dart';
import '../../data/services/sale_service.dart';
import 'package:electrosoft/core/services/notification_service.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  final ProductService _productService = ProductService();
  final OrderService _orderService = OrderService();
  final SaleService _saleService = SaleService();

  Map<int, double> _ventasPorMes = {};

  int _numCriticos = 0;
  List<Product> _productosCriticos = [];
  int _pedidosPendientes = 0;
  int _pedidosUrgentes = 0;
  double _ventasTotales = 0;

  final NotificationServiceAPI _notificationServiceAPI =
      NotificationServiceAPI();
  List<dynamic> _recentNotifications = [];
  int _unreadNotifications = 0;

  bool _loadingVentas = true;
  bool _isLoadingStock = true;
  bool _loadingNotifications = true;

  int _selectedYear = DateTime.now().year;
  final List<int> _availableYears = [
    DateTime.now().year - 2,
    DateTime.now().year - 1,
    DateTime.now().year,
  ];

  List<dynamic> _latestNotifications(Iterable<dynamic> notifications) {
    final sortedNotifications = List<dynamic>.from(notifications);
    sortedNotifications.sort((a, b) {
      final dateA =
          DateTime.tryParse(a['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final dateB =
          DateTime.tryParse(b['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });
    return sortedNotifications.take(3).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _calcularStockCritico();
    _cargarPedidosPendientes();
    _cargarVentas();
    _cargarNotificaciones();
    _notificationServiceAPI.startPolling((notifications, initial) async {
      if (mounted) {
        setState(() {
          if (initial) {
            _recentNotifications = _latestNotifications(notifications);
            _unreadNotifications = notifications
                .where((n) => n['isRead'] == false)
                .length;
          } else {
            _recentNotifications = _latestNotifications([
              ...notifications,
              ..._recentNotifications,
            ]);
            _unreadNotifications += notifications
                .where((n) => n['isRead'] == false)
                .length;
          }
          _loadingNotifications = false;
        });
        _calcularStockCritico();
        _cargarPedidosPendientes();
        _cargarVentas();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationServiceAPI.stopPolling();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _notificationServiceAPI.startPolling((notifications, initial) async {
        if (!mounted) return;
        setState(() {
          if (initial) {
            _recentNotifications = _latestNotifications(notifications);
            _unreadNotifications = notifications
                .where((n) => n['isRead'] == false)
                .length;
          } else {
            _recentNotifications = _latestNotifications([
              ...notifications,
              ..._recentNotifications,
            ]);
            _unreadNotifications += notifications
                .where((n) => n['isRead'] == false)
                .length;
          }
        });
      });
    }
  }

  Future<void> _cargarNotificaciones() async {
    try {
      final notifications = await _notificationServiceAPI
          .getRecentNotifications();
      if (mounted) {
        setState(() {
          _recentNotifications = _latestNotifications(notifications);
          _unreadNotifications = notifications
              .where((n) => n['isRead'] == false)
              .length;
          _loadingNotifications = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingNotifications = false);
      }
    }
  }

  Future<void> _calcularStockCritico() async {
    try {
      final productos = await _productService.obtenerProductos();
      if (mounted) {
        setState(() {
          _numCriticos = productos.where((p) => p.stock <= 10).length;
          _productosCriticos = productos
              .where((p) => p.status && p.stock >= 0 && p.stock <= 10)
              .toList();
          _numCriticos = _productosCriticos.length;
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
        if (!venta.isActiva) continue;
        if (venta.fechaVenta.year != _selectedYear) continue;

        final mes = venta.fechaVenta.month;
        ventasPorMes[mes] = (ventasPorMes[mes] ?? 0) + venta.montoCobrado;

        total += venta.montoCobrado;
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
      if (mounted) {
        setState(() {
          _loadingVentas = false;
        });
      }
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
                  _NotificationBadge(
                    unreadCount: _unreadNotifications,
                    onTap: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );

                      if (mounted && result == true) {
                        _cargarNotificaciones();
                      }
                    },
                  ),
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
                  _buildFilters(),
                  const SizedBox(height: 24),
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
                          'VENTAS DEL MES',
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
                          onTap: _numCriticos > 0
                              ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CriticalStockScreen(
                                      products: _productosCriticos,
                                    ),
                                  ),
                                )
                              : null,
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
                        onPressed: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );

                          if (mounted && result == true) {
                            _cargarNotificaciones();
                          }
                        },
                        child: const Text(
                          'Ver todo',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),

                  if (_loadingNotifications)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(color: Colors.orange),
                      ),
                    )
                  else if (_recentNotifications.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('No hay actividad reciente'),
                      ),
                    )
                  else
                    ..._recentNotifications.map((notif) {
                      IconData iconData = Icons.notifications;
                      Color iconColor = Colors.orange;

                      if (notif['type'] == 'SALE') {
                        iconData = Icons.shopping_cart_checkout;
                        iconColor = Colors.green;
                      } else if (notif['type'] == 'USER') {
                        iconData = Icons.person_add_outlined;
                        iconColor = Colors.blue;
                      } else if (notif['type'] == 'PAYMENT') {
                        iconData = Icons.attach_money;
                        iconColor = Colors.amber;
                      }

                      String timeText = 'Ahora';
                      if (notif['createdAt'] != null) {
                        try {
                          final date = DateTime.parse(notif['createdAt']);
                          final diff = DateTime.now().difference(date);
                          if (diff.inMinutes < 60) {
                            timeText = 'Hace ${diff.inMinutes}m';
                          } else if (diff.inHours < 24) {
                            timeText = 'Hace ${diff.inHours}h';
                          } else {
                            timeText = 'Hace ${diff.inDays}d';
                          }
                        } catch (_) {}
                      }

                      return ActivityItem(
                        title: notif['title'] ?? 'Notificación',
                        subtitle: notif['description'] ?? '',
                        time: timeText,
                        icon: iconData,
                        iconColor: iconColor,
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rendimiento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                letterSpacing: 0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedYear,
                  dropdownColor: Colors.white,
                  focusColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedYear = newValue;
                        _loadingVentas = true;
                      });
                      _cargarVentas();
                    }
                  },
                  items: _availableYears.map<DropdownMenuItem<int>>((
                    int value,
                  ) {
                    final isSelected = value == _selectedYear;
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationBadge({required this.unreadCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
          if (unreadCount > 0)
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 10,
                height: 10,
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
