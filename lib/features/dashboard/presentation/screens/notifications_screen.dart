import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('HOY'),
          _notificationItem(
            title: 'Stock Crítico',
            description: 'El producto "Bombillo LED 12W" alcanzó el mínimo de 10 unidades.',
            time: 'Hace 30 min',
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.redAccent,
            isUnread: true,
          ),
          _notificationItem(
            title: 'Nueva Venta',
            description: 'Se ha registrado una venta por \$450,000.',
            time: 'Hace 30 min',
            icon: Icons.monetization_on_outlined,
            iconColor: Colors.green,
            isUnread: true,
          ),
          _notificationItem(
            title: 'Stock Crítico',
            description: 'El producto "Cable THW Cal.12 (100m)" alcanzó el mínimo de 10 unidades.',
            time: 'Hace 2 horas',
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.redAccent,
            isUnread: true,
          ),
          const SizedBox(height: 20),
          _sectionTitle('AYER'),
          _notificationItem(
            title: 'Nuevo Registro',
            description: 'Un nuevo cliente se ha unido a la plataforma.',
            time: 'Ayer, 5:30 PM',
            icon: Icons.person_add_alt_1_rounded,
            iconColor: Colors.orange,
            isUnread: false,
          ),
          _notificationItem(
            title: 'Actualización de Perfil',
            description: 'Has cambiado tu foto de perfil correctamente.',
            time: 'Ayer, 4:30 PM',
            icon: Icons.person_outline_rounded,
            iconColor: Colors.blueAccent,
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.textMuted,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _notificationItem({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color iconColor,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: isUnread ? Border.all(color: AppTheme.primary.withValues(alpha: 0.01), width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.01),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            if (isUnread)
              const CircleAvatar(radius: 4, backgroundColor: AppTheme.primary),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.3),
            ),
            const SizedBox(height: 8),
            Text(time, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }
}