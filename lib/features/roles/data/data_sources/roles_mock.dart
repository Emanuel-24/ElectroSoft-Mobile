import '../../domain/entities/role.dart';

class RolesMock {
  static const listado = [
    Rol(
      title: "Administrador",
      description: "Acceso total a todas las funciones del sistema, configuración global y gestión de usuarios.",
      time: "Hace 2h",
    ),
    Rol(
      title: "Empleado",
      description: "Permisos para gestión de ventas, procesamiento de pedidos e inventario básico.",
      time: "Hace 1d",
    ),
    Rol(
      title: "Cliente",
      description: "Visualización de catálogo de productos, seguimiento de pedidos y gestión de perfil.",
      time: "Hace 3d",
    ),
  ];
}