import '../../domain/entities/product.dart';

class ProductosMock {
  static final Map<String, List<Producto>> porCategoria = {
    'Iluminación': [
      Producto(
        nombre: 'Foco LED 12W Alta Potencia',
        categoria: 'Iluminación',
        stock: 50,
        precio: 15000,
        serial: 'LED-12W-001',
        garantia: '12 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Potencia', medida: 'watts', valor: '12W'),
          Caracteristica(caracteristica: 'Flujo luminoso', medida: 'lúmenes', valor: '1200lm'),
          Caracteristica(caracteristica: 'Temperatura de color', medida: 'Kelvin', valor: '4000K'),
          Caracteristica(caracteristica: 'Ángulo de apertura', medida: 'grados', valor: '120°'),
          Caracteristica(caracteristica: 'Índice de reproducción cromática', medida: 'CRI', valor: '>80'),
        ],
      ),
      Producto(
        nombre: 'Lámpara Industrial de Techo',
        categoria: 'Iluminación',
        stock: 12,
        precio: 45000,
        serial: 'LAMP-IND-002',
        garantia: '6 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Potencia', medida: 'watts', valor: '50W'),
          Caracteristica(caracteristica: 'Tipo de instalación', medida: '', valor: 'Sobreponer'),
          Caracteristica(caracteristica: 'Material', medida: '', valor: 'Aluminio'),
          Caracteristica(caracteristica: 'IP', medida: '', valor: 'IP65'),
          Caracteristica(caracteristica: 'Dimensiones', medida: 'mm', valor: '300x300x120'),
        ],
      ),
      Producto(
        nombre: 'Panel LED Inteligente RGB',
        categoria: 'Iluminación',
        stock: 5,
        precio: 2900,
        serial: 'LED-RGB-003',
        garantia: '24 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Potencia', medida: 'watts', valor: '24W'),
          Caracteristica(caracteristica: 'Control', medida: '', valor: 'WiFi + Bluetooth'),
          Caracteristica(caracteristica: 'App compatible', medida: '', valor: 'Smart Life'),
          Caracteristica(caracteristica: 'Colores', medida: '', valor: '16 millones'),
        ],
      ),
      Producto(
        nombre: 'Reflector Exterior 50W',
        categoria: 'Iluminación',
        stock: 24,
        precio: 38000,
        serial: 'REF-50W-004',
        garantia: '12 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Potencia', medida: 'watts', valor: '50W'),
          Caracteristica(caracteristica: 'IP', medida: '', valor: 'IP66'),
          Caracteristica(caracteristica: 'Sensor movimiento', medida: '', valor: 'Sí'),
          Caracteristica(caracteristica: 'Alcance', medida: 'metros', valor: '15'),
        ],
      ),
      Producto(
        nombre: 'Tira LED 5mts Bluetooth',
        categoria: 'Iluminación',
        stock: 15,
        precio: 18000,
        serial: 'LED-STRIP-005',
        garantia: '6 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Longitud', medida: 'metros', valor: '5'),
          Caracteristica(caracteristica: 'Potencia por metro', medida: 'watts', valor: '14.4W'),
          Caracteristica(caracteristica: 'Control', medida: '', valor: 'Bluetooth'),
          Caracteristica(caracteristica: 'Cortable', medida: '', valor: 'Sí (cada 5cm)'),
        ],
      ),
    ],
    'Cables': [
      Producto(
        nombre: 'Cable THW Cal.12 (100m)',
        categoria: 'Cables',
        stock: 8,
        precio: 12000,
        serial: 'CBL-THW12-001',
        garantia: '3 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Calibre', medida: 'AWG', valor: '12'),
          Caracteristica(caracteristica: 'Longitud', medida: 'metros', valor: '100'),
          Caracteristica(caracteristica: 'Tipo', medida: '', valor: 'THW'),
          Caracteristica(caracteristica: 'Temperatura máxima', medida: '°C', valor: '90°C'),
          Caracteristica(caracteristica: 'Voltaje nominal', medida: 'V', valor: '600V'),
        ],
      ),
      Producto(
        nombre: 'Cable THHN Cal.10 Negro',
        categoria: 'Cables',
        stock: 20,
        precio: 95000,
        serial: 'CBL-THHN10-002',
        garantia: '3 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Calibre', medida: 'AWG', valor: '10'),
          Caracteristica(caracteristica: 'Longitud', medida: 'metros', valor: '100'),
          Caracteristica(caracteristica: 'Tipo', medida: '', valor: 'THHN'),
          Caracteristica(caracteristica: 'Color', medida: '', valor: 'Negro'),
          Caracteristica(caracteristica: 'Material conductor', medida: '', valor: 'Cobre'),
        ],
      ),
      Producto(
        nombre: 'Cable Coaxial RG-6 (50m)',
        categoria: 'Cables',
        stock: 35,
        precio: 42000,
        serial: 'CBL-COAX-003',
        garantia: '6 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Impedancia', medida: 'Ohms', valor: '75'),
          Caracteristica(caracteristica: 'Longitud', medida: 'metros', valor: '50'),
          Caracteristica(caracteristica: 'Tipo', medida: '', valor: 'RG-6'),
          Caracteristica(caracteristica: 'Aplicación', medida: '', valor: 'TV/SAT'),
        ],
      ),
    ],
    'Herramientas': [
      Producto(
        nombre: 'Multímetro Digital Pro',
        categoria: 'Herramientas',
        stock: 7,
        precio: 55000,
        serial: 'TOOL-MULT-001',
        garantia: '12 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Rango de voltaje', medida: 'V', valor: '0-600V'),
          Caracteristica(caracteristica: 'Rango de corriente', medida: 'A', valor: '0-10A'),
          Caracteristica(caracteristica: 'Resistencia', medida: 'Ohms', valor: '0-40M'),
          Caracteristica(caracteristica: 'Pantalla', medida: 'pulgadas', valor: '3.5"'),
        ],
      ),
      Producto(
        nombre: 'Pinzas de Corte Diagonales',
        categoria: 'Herramientas',
        stock: 40,
        precio: 8500,
        serial: 'TOOL-PINZ-002',
        garantia: '6 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Longitud', medida: 'mm', valor: '150'),
          Caracteristica(caracteristica: 'Material', medida: '', valor: 'Acero CR-V'),
          Caracteristica(caracteristica: 'Aislamiento', medida: 'V', valor: '1000V'),
          Caracteristica(caracteristica: 'Dureza', medida: 'HRC', valor: '58-62'),
        ],
      ),
      Producto(
        nombre: 'Destornillador Aislado 1000V',
        categoria: 'Herramientas',
        stock: 25,
        precio: 14000,
        serial: 'TOOL-DEST-003',
        garantia: '12 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Longitud', medida: 'mm', valor: '200'),
          Caracteristica(caracteristica: 'Tipo', medida: '', valor: 'Plano 6mm'),
          Caracteristica(caracteristica: 'Aislamiento', medida: 'V', valor: '1000V'),
          Caracteristica(caracteristica: 'Norma', medida: '', valor: 'IEC 60900'),
        ],
      ),
    ],
    'Protección': [
      Producto(
        nombre: 'Breaker 2x20A Siemens',
        categoria: 'Protección',
        stock: 60,
        precio: 18000,
        serial: 'PROT-BRK-001',
        garantia: '24 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Polos', medida: '', valor: '2'),
          Caracteristica(caracteristica: 'Corriente nominal', medida: 'A', valor: '20'),
          Caracteristica(caracteristica: 'Poder de corte', medida: 'kA', valor: '10'),
          Caracteristica(caracteristica: 'Curva', medida: '', valor: 'C'),
        ],
      ),
      Producto(
        nombre: 'Caja Nema Metálica 30x30',
        categoria: 'Protección',
        stock: 15,
        precio: 32000,
        serial: 'PROT-CAJ-002',
        garantia: '12 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Dimensiones', medida: 'cm', valor: '30x30x15'),
          Caracteristica(caracteristica: 'Material', medida: '', valor: 'Acero galvanizado'),
          Caracteristica(caracteristica: 'IP', medida: '', valor: 'IP65'),
          Caracteristica(caracteristica: 'Color', medida: '', valor: 'Gris'),
        ],
      ),
      Producto(
        nombre: 'Tablero 12 Circuitos Empotr.',
        categoria: 'Protección',
        stock: 10,
        precio: 78000,
        serial: 'PROT-TAB-003',
        garantia: '18 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Circuitos', medida: '', valor: '12'),
          Caracteristica(caracteristica: 'Monofásico', medida: 'V', valor: '120/240'),
          Caracteristica(caracteristica: 'Material', medida: '', valor: 'Plástico ignífugo'),
          Caracteristica(caracteristica: 'Tipo', medida: '', valor: 'Empotrar'),
        ],
      ),
    ],
    'Interruptores': [
      Producto(
        nombre: 'Apagador Simple Bticino',
        categoria: 'Interruptores',
        stock: 80,
        precio: 6500,
        serial: 'INT-SIMP-001',
        garantia: '12 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Polos', medida: '', valor: '1'),
          Caracteristica(caracteristica: 'Corriente', medida: 'A', valor: '10'),
          Caracteristica(caracteristica: 'Voltaje', medida: 'V', valor: '250'),
          Caracteristica(caracteristica: 'Color', medida: '', valor: 'Blanco'),
        ],
      ),
      Producto(
        nombre: 'Apagador Doble con LED',
        categoria: 'Interruptores',
        stock: 45,
        precio: 12000,
        serial: 'INT-DOB-002',
        garantia: '12 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Polos', medida: '', valor: '2'),
          Caracteristica(caracteristica: 'LED indicador', medida: '', valor: 'Sí'),
          Caracteristica(caracteristica: 'Corriente', medida: 'A', valor: '10'),
          Caracteristica(caracteristica: 'Acabado', medida: '', valor: 'Mate'),
        ],
      ),
      Producto(
        nombre: 'Apagador Inteligente WiFi',
        categoria: 'Interruptores',
        stock: 9,
        precio: 22500,
        serial: 'INT-WIFI-003',
        garantia: '18 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Control', medida: '', valor: 'WiFi + App'),
          Caracteristica(caracteristica: 'Compatibilidad', medida: '', valor: 'Alexa, Google'),
          Caracteristica(caracteristica: 'Potencia máxima', medida: 'W', valor: '1200'),
          Caracteristica(caracteristica: 'Programable', medida: '', valor: 'Sí'),
        ],
      ),
    ],
    'Motores': [
      Producto(
        nombre: 'Motor Monofásico 1/2 HP',
        categoria: 'Motores',
        stock: 5,
        precio: 210000,
        serial: 'MOT-MONO-001',
        garantia: '12 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Potencia', medida: 'HP', valor: '1/2'),
          Caracteristica(caracteristica: 'Fases', medida: '', valor: 'Monofásico'),
          Caracteristica(caracteristica: 'Velocidad', medida: 'RPM', valor: '1725'),
          Caracteristica(caracteristica: 'Voltaje', medida: 'V', valor: '110/220'),
        ],
      ),
      Producto(
        nombre: 'Motor Trifásico 1 HP',
        categoria: 'Motores',
        stock: 3,
        precio: 380000,
        serial: 'MOT-TRI-002',
        garantia: '12 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Potencia', medida: 'HP', valor: '1'),
          Caracteristica(caracteristica: 'Fases', medida: '', valor: 'Trifásico'),
          Caracteristica(caracteristica: 'Velocidad', medida: 'RPM', valor: '3450'),
          Caracteristica(caracteristica: 'Voltaje', medida: 'V', valor: '220/440'),
        ],
      ),
      Producto(
        nombre: 'Variador de Frecuencia 2HP',
        categoria: 'Motores',
        stock: 7,
        precio: 145000,
        serial: 'MOT-VFD-003',
        garantia: '24 meses',
        caracteristicas: const [
          Caracteristica(caracteristica: 'Potencia', medida: 'HP', valor: '2'),
          Caracteristica(caracteristica: 'Entrada', medida: 'V', valor: '220 monofásico'),
          Caracteristica(caracteristica: 'Salida', medida: 'V', valor: '220 trifásico'),
          Caracteristica(caracteristica: 'Control', medida: '', valor: 'Potenciometro + Panel'),
        ],
      ),
    ],
  };

  // Método para obtener todos los productos
  static List<Producto> obtenerTodos() {
    return porCategoria.values.expand((lista) => lista).toList();
  }

  // Método para buscar productos por nombre
  static List<Producto> buscarPorNombre(String query) {
    if (query.isEmpty) return obtenerTodos();
    return obtenerTodos()
        .where((producto) =>
            producto.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}