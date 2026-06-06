import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../../../core/theme/app_theme.dart';

class UsuarioCard extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback onTap;
  const UsuarioCard({super.key, required this.usuario, required this.onTap});

  Color get _rolColor => usuario.roleName.toLowerCase().contains('admin')
      ? AppTheme.amarillo
      : AppTheme.gris;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 4, color: AppTheme.amarillo),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Avatar(fullName: usuario.fullName),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    usuario.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    usuario.roleName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _rolColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _EstadoBadge(isActive: usuario.isActive),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 8),
                        Text(
                          'Último acceso',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          usuario.lastAccess,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String fullName;
  const _Avatar({required this.fullName});

  String get _iniciales {
    final p = fullName.trim().split(' ');
    return p.length >= 2
        ? '${p[0][0]}${p[1][0]}'.toUpperCase()
        : p[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppTheme.avatarBg2,
      child: Text(
        _iniciales,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _EstadoBadge extends StatelessWidget {
  final bool isActive;
  const _EstadoBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppTheme.verde : AppTheme.gris;
    final texto = isActive ? 'Activo' : 'Inactivo';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}