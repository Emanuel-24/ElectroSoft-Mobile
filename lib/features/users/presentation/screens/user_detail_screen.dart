import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/user.dart';
import '../widgets/user_detail_widgets.dart';
import '../../../../shared/widgets/main_shell.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/entities/auth_response.dart';

class UsuarioDetalleScreen extends StatelessWidget {
  final Usuario usuario;
  final UserSession usuarioLogueado;

  const UsuarioDetalleScreen({
    super.key,
    required this.usuario,
    required this.usuarioLogueado,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: const ElectroAppBar(
        title: 'Detalle de Usuario',
        showSearch: false,
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  BigAvatar(fullName: usuario.fullName),
                  const SizedBox(height: 16),
                  Text(
                    usuario.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  RoleChip(roleName: usuario.roleName),
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

                  InfoCard(
                    items: [
                      InfoItem(
                        icon: Icons.badge_outlined,
                        label: 'Rol del sistema',
                        value: usuario.roleName,
                      ),
                      InfoItem(
                        icon: Icons.credit_card_rounded,
                        label: 'Identificación',
                        value:
                            '${usuario.documentAbbreviation} - ${usuario.documentNumber}',
                      ),
                      InfoItem(
                        icon: Icons.email_outlined,
                        label: 'Correo electrónico',
                        value: usuario.email,
                      ),
                      InfoItem(
                        icon: Icons.phone_android_outlined,
                        label: 'Número de teléfono',
                        value: usuario.phone.isEmpty
                            ? 'No registrado'
                            : usuario.phone,
                      ),
                      InfoItem(
                        icon: Icons.history_rounded,
                        label: 'Último acceso registrado',
                        value: usuario.lastAccess,
                      ),
                      InfoItem(
                        icon: Icons.circle,
                        iconColor: usuario.isActive
                            ? AppTheme.verde
                            : AppTheme.gris,
                        label: 'Estado de la cuenta',
                        value: usuario.isActive ? 'Activo' : 'Inactivo',
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
            MaterialPageRoute(
              builder: (_) =>
                  MainShell(initialIndex: index, usuario: usuarioLogueado),
            ),
          );
        },
      ),
    );
  }
}