import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoriasMock {
  static const listado = [
    Categoria(nombre: 'Cables', cantidad: 24, icono: Icons.cable_rounded),
    Categoria(nombre: 'Iluminación', cantidad: 45, icono: Icons.light_rounded),
    Categoria(nombre: 'Herramientas', cantidad: 18, icono: Icons.construction_rounded),
    Categoria(nombre: 'Protección', cantidad: 32, icono: Icons.shield_outlined),
    Categoria(nombre: 'Interruptores', cantidad: 15, icono: Icons.toggle_on_rounded),
    Categoria(nombre: 'Motores', cantidad: 10, icono: Icons.settings_rounded),
  ];
}