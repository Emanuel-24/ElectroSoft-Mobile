import 'package:flutter/material.dart';
import 'user_detail_screen.dart';

// ─── Modelo ───────────────────────────────────────────────────────────────────

enum EstadoUsuario { activo, inactivo }

class Usuario {
  final String nombre;
  final String rol;
  final String ultimoAcceso;
  final EstadoUsuario estado;

  const Usuario({
    required this.nombre,
    required this.rol,
    required this.ultimoAcceso,
    required this.estado,
  });
}

// ─── Datos de ejemplo ─────────────────────────────────────────────────────────

const _usuarios = [
  Usuario(
    nombre: 'Juan Pérez',
    rol: 'Admin',
    ultimoAcceso: 'Hoy, 09:30 AM',
    estado: EstadoUsuario.activo,
  ),
  Usuario(
    nombre: 'María González',
    rol: 'Empleado',
    ultimoAcceso: 'Ayer, 18:45 PM',
    estado: EstadoUsuario.activo,
  ),
  Usuario(
    nombre: 'Carlos Ruiz',
    rol: 'Cliente',
    ultimoAcceso: 'Hace 5 días',
    estado: EstadoUsuario.inactivo,
  ),
  Usuario(
    nombre: 'Ana López',
    rol: 'Empleado',
    ultimoAcceso: 'Hace 2 horas',
    estado: EstadoUsuario.activo,
  ),
];

// ─── Colores ──────────────────────────────────────────────────────────────────

const _verde = Color(0xFF4CAF50);
const _gris = Color(0xFF9E9E9E);
const _amarillo = Color(0xFFFFC107);
const _avatarBg = Color(0xFFBDBDBD);

// ─── Pantalla lista ───────────────────────────────────────────────────────────

class UsuariosScreen extends StatelessWidget {
  final String query;
  const UsuariosScreen({super.key, this.query = ''});

  List<Usuario> get _filtrados {
    if (query.isEmpty) return _usuarios;
    final q = query.toLowerCase();
    return _usuarios
        .where(
          (u) =>
              u.nombre.toLowerCase().contains(q) ||
              u.rol.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filtrados.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _UsuarioCard(
        usuario: _filtrados[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UsuarioDetalleScreen(usuario: _filtrados[i]),
          ),
        ),
      ),
    );
  }
}

// ─── Tarjeta de usuario ───────────────────────────────────────────────────────

class _UsuarioCard extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback onTap;
  const _UsuarioCard({required this.usuario, required this.onTap});

  Color get _rolColor =>
      usuario.rol.toLowerCase() == 'admin' ? _amarillo : _gris;

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
              color: Colors.black.withOpacity(0.04),
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
                // Barra amarilla izquierda
                Container(width: 4, color: _amarillo),

                // Contenido
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
                            _Avatar(nombre: usuario.nombre),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    usuario.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    usuario.rol,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _rolColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _EstadoBadge(estado: usuario.estado),
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
                          usuario.ultimoAcceso,
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

// ─── Avatar gris con iniciales ────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String nombre;
  const _Avatar({required this.nombre});

  String get _iniciales {
    final p = nombre.trim().split(' ');
    return p.length >= 2
        ? '${p[0][0]}${p[1][0]}'.toUpperCase()
        : p[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: _avatarBg,
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

// ─── Badge de estado ──────────────────────────────────────────────────────────

class _EstadoBadge extends StatelessWidget {
  final EstadoUsuario estado;
  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final activo = estado == EstadoUsuario.activo;
    final color = activo ? _verde : _gris;
    final texto = activo ? 'Activo' : 'Inactivo';

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
