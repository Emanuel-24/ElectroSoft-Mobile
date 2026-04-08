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