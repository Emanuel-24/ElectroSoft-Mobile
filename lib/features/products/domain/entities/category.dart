import 'package:flutter/widgets.dart';

class Categoria {
  final String nombre;
  final int cantidad;
  final IconData icono;

  const Categoria({
    required this.nombre,
    required this.cantidad,
    required this.icono,
  });
}