import '../../domain/entities/product.dart';

class ProductosMock {
  static const Map<String, List<Producto>> porCategoria = {
    'Iluminación': [
      Producto(
        nombre: 'Foco LED 12W Alta Potencia',
        categoria: 'Iluminación',
        stock: 50,
        precio: 15000,
      ),
      Producto(
        nombre: 'Lámpara Industrial de Techo',
        categoria: 'Iluminación',
        stock: 12,
        precio: 45000,
      ),
      Producto(
        nombre: 'Panel LED Inteligente RGB',
        categoria: 'Iluminación',
        stock: 5,
        precio: 2900,
      ),
      Producto(
        nombre: 'Reflector Exterior 50W',
        categoria: 'Iluminación',
        stock: 24,
        precio: 38000,
      ),
      Producto(
        nombre: 'Tira LED 5mts Bluetooth',
        categoria: 'Iluminación',
        stock: 15,
        precio: 18000,
      ),
    ],
    'Cables': [
      Producto(
        nombre: 'Cable THW Cal.12 (100m)',
        categoria: 'Cables',
        stock: 8,
        precio: 12000,
      ),
      Producto(
        nombre: 'Cable THHN Cal.10 Negro',
        categoria: 'Cables',
        stock: 20,
        precio: 95000,
      ),
      Producto(
        nombre: 'Cable Coaxial RG-6 (50m)',
        categoria: 'Cables',
        stock: 35,
        precio: 42000,
      ),
    ],
    'Herramientas': [
      Producto(
        nombre: 'Multímetro Digital Pro',
        categoria: 'Herramientas',
        stock: 7,
        precio: 55000,
      ),
      Producto(
        nombre: 'Pinzas de Corte Diagonales',
        categoria: 'Herramientas',
        stock: 40,
        precio: 8500,
      ),
      Producto(
        nombre: 'Destornillador Aislado 1000V',
        categoria: 'Herramientas',
        stock: 25,
        precio: 14000,
      ),
    ],
    'Protección': [
      Producto(
        nombre: 'Breaker 2x20A Siemens',
        categoria: 'Protección',
        stock: 60,
        precio: 18000,
      ),
      Producto(
        nombre: 'Caja Nema Metálica 30x30',
        categoria: 'Protección',
        stock: 15,
        precio: 32000,
      ),
      Producto(
        nombre: 'Tablero 12 Circuitos Empotr.',
        categoria: 'Protección',
        stock: 10,
        precio: 78000,
      ),
    ],
    'Interruptores': [
      Producto(
        nombre: 'Apagador Simple Bticino',
        categoria: 'Interruptores',
        stock: 80,
        precio: 6500,
      ),
      Producto(
        nombre: 'Apagador Doble con LED',
        categoria: 'Interruptores',
        stock: 45,
        precio: 12000,
      ),
      Producto(
        nombre: 'Apagador Inteligente WiFi',
        categoria: 'Interruptores',
        stock: 9,
        precio: 22500,
      ),
    ],
    'Motores': [
      Producto(
        nombre: 'Motor Monofásico 1/2 HP',
        categoria: 'Motores',
        stock: 5,
        precio: 21000,
      ),
      Producto(
        nombre: 'Motor Trifásico 1 HP',
        categoria: 'Motores',
        stock: 3,
        precio: 38000,
      ),
      Producto(
        nombre: 'Variador de Frecuencia 2HP',
        categoria: 'Motores',
        stock: 7,
        precio: 14500,
      ),
    ],
  };
}
