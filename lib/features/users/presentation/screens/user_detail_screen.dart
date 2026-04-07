import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_theme.dart';
import 'users_screen.dart';

class UsuarioDetalleScreen extends StatelessWidget {
  final Usuario usuario;
  const UsuarioDetalleScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElectroAppBar(
        title: 'Usuarios',
        showSearch: false,
        onAvatarTap: () {},
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Vista detalle del usuario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Volver',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElectroBottomNav(
        items: ElectroNavItem.defaults(),
        initialIndex: 1,
        onTabChanged: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }
}