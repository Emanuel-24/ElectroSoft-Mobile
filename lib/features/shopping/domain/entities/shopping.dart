import 'package:flutter/material.dart';

class Compra {
  final String id;
  final String proveedor;
  final DateTime fecha;
  final double total;
  final List<ItemCompra> items;
  final EstadoCompra estado;

  const Compra({
    required this.id,
    required this.proveedor,
    required this.fecha,
    required this.total,
    required this.items,
    required this.estado,
  });

  int get cantidadItems => items.length;
}

class ItemCompra {
  final String productoId;
  final String productoNombre;
  final int cantidad;
  final double precioUnitario;

  const ItemCompra({
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
  });

  double get subtotal => cantidad * precioUnitario;
}

enum EstadoCompra {
  activa,
  anulada;

  String get displayName {
    switch (this) {
      case EstadoCompra.activa:
        return 'Activa';
      case EstadoCompra.anulada:
        return 'Anulada';
    }
  }

  Color get color {
    switch (this) {
      case EstadoCompra.activa:
        return Colors.green;
      case EstadoCompra.anulada:
        return Colors.red;
    }
  }
}