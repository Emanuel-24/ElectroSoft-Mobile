class Producto {
  final String nombre;
  final String categoria;
  final int stock;
  final double precio;
  final String serial;
  final String garantia;
  final List<Caracteristica> caracteristicas;

  const Producto({
    required this.nombre,
    required this.categoria,
    required this.stock,
    required this.precio,
    this.serial = '',
    this.garantia = '',
    this.caracteristicas = const [],
  });

  // Copiar producto con nuevos valores
  Producto copyWith({
    String? nombre,
    String? categoria,
    int? stock,
    double? precio,
    String? serial,
    String? garantia,
    List<Caracteristica>? caracteristicas,
  }) {
    return Producto(
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      stock: stock ?? this.stock,
      precio: precio ?? this.precio,
      serial: serial ?? this.serial,
      garantia: garantia ?? this.garantia,
      caracteristicas: caracteristicas ?? this.caracteristicas,
    );
  }
}

class Caracteristica {
  final String caracteristica;
  final String medida;
  final String valor;

  const Caracteristica({
    required this.caracteristica,
    required this.medida,
    required this.valor,
  });

  // Para convertir a Map (si necesitas JSON)
  Map<String, dynamic> toJson() => {
        'caracteristica': caracteristica,
        'medida': medida,
        'valor': valor,
      };

  // Para crear desde Map
  factory Caracteristica.fromJson(Map<String, dynamic> json) {
    return Caracteristica(
      caracteristica: json['caracteristica'] as String,
      medida: json['medida'] as String,
      valor: json['valor'] as String,
    );
  }
}