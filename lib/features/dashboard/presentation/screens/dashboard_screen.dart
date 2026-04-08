// PANTALLA PRINCIPAL DEL DASHBOARD

import 'package:flutter/material.dart';
import '../widgets/stats_card.dart';
import '../widgets/activity_item.dart';
import '../screens/notifications_screen.dart';
import '../../../products/data/data_sources/products_mock.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  int get _countStockCritico {
    final todosLosProductos = ProductosMock.porCategoria.values
        .expand((lista) => lista)
        .toList();
    
    return todosLosProductos.where((p) => p.stock <= 10).length;
  }

  @override
  Widget build(BuildContext context) {
    // 3. Guardamos el resultado en una variable para usarla en la UI
    final int numCriticos = _countStockCritico;
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
                  const StatsCard(
                    title: 'VENTAS TOTALES',
                    value: '\$12,450.00',
                    percentage: '+12%',
                    isMain: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          title: 'Pedidos Pendientes',
                          value: '24',
                          subtitle: '5 urgentes',
                          icon: Icons.shopping_cart_outlined,
                          accentColor: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: StatsCard(
                          title: 'Stock Crítico',
                          value: '$numCriticos',
                          subtitle: numCriticos > 0 
                              ? 'Requiere atención' 
                              : 'Todo en orden',
                          icon: Icons.inventory_2_outlined,
                          accentColor: numCriticos > 0 ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Título Actividad
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
                        onPressed: () {},
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget de la campana con el punto rojo
class _NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell( // <--- Agregamos InkWell para que sea "clicable"
      onTap: () {
        // ── Navegación a la pantalla de notificaciones ──
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        );
      },
      borderRadius: BorderRadius.circular(12), // Para que el efecto de toque sea redondeado
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