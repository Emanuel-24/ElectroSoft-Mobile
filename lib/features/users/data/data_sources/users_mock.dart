import '../../domain/entities/user.dart';

class UsuariosMock {
  static const listado = [
    Usuario(
      nombre: 'Juan Santaaa',
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
      rol: 'Empleado',
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
}
