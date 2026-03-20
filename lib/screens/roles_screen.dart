import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        RoleCard(
          title: "Admin",
          id: "R-001",
          description:
              "Acceso total a todas las funciones del sistema, configuración global y gestión de usuarios.",
          time: "Hace 2h",
        ),
        RoleCard(
          title: "Empleado",
          id: "R-002",
          description:
              "Permisos para gestión de ventas, procesamiento de pedidos e inventario básico.",
          time: "Hace 1d",
        ),
        RoleCard(
          title: "Cliente",
          id: "R-003",
          description:
              "Visualización de catálogo de productos, seguimiento de pedidos y gestión de perfil.",
          time: "Hace 3d",
        ),
      ],
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final String id;
  final String description;
  final String time;

  const RoleCard({
    super.key,
    required this.title,
    required this.id,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 🔶 Línea amarilla
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
          ),

          // 📄 CONTENIDO
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Título
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "ID: $id",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),

                const SizedBox(height: 10),

                Text(description, style: const TextStyle(fontSize: 13)),

                const SizedBox(height: 12),

                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // 🟢 ACTIVO (ARRIBA DERECHA)
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.circle, size: 8, color: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    "Activo",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 👁 BOTÓN (ABAJO DERECHA)
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7FF),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8), // 👈 más pequeño
              child: const Icon(
                Icons.visibility,
                size: 18, // 👈 más pequeño
                color: Colors.indigo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
