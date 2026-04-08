import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/user.dart';
import '../widgets/user_detail_widgets.dart';
import '../../../../shared/widgets/main_shell.dart';

class UsuarioDetalleScreen extends StatelessWidget {
  final Usuario usuario;
  final String email = "usuario@electrosoft.com";
  final String telefono = "+57 300 123 4567";
  const UsuarioDetalleScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final bool esActivo = usuario.estado == EstadoUsuario.activo;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9), // Tu gris de fondo
      appBar: ElectroAppBar(
        title: 'Detalle de Usuario',
        showSearch: false,
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER CON AVATAR ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  BigAvatar(nombre: usuario.nombre),
                  const SizedBox(height: 16),
                  Text(
                    usuario.nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  RoleChip(rol: usuario.rol),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información General',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // --- TARJETA DE DATOS ---
                  InfoCard(
                    items: [
                      InfoItem(
                        icon: Icons.badge_outlined,
                        label: 'Rol del sistema',
                        value: usuario.rol,
                      ),
                      InfoItem(
                        icon: Icons.email_outlined,
                        label: 'Correo electrónico',
                        value: email,
                      ),
                      InfoItem(
                        icon: Icons.phone_android_outlined,
                        label: 'Número de teléfono',
                        value: telefono,
                      ),
                      InfoItem(
                        icon: Icons.history_rounded,
                        label: 'Último acceso registrado',
                        value: usuario.ultimoAcceso,
                      ),
                      InfoItem(
                        icon: Icons.circle,
                        iconColor: esActivo ? Colors.green : Colors.grey,
                        label: 'Estado de la cuenta',
                        value: esActivo ? 'Activo' : 'Inactivo',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElectroBottomNav(
        items: ElectroNavItem.defaults(),
        initialIndex: 1,
        onTabChanged: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainShell(initialIndex: index)),
          );
        },
      ),
    );
  }
}
