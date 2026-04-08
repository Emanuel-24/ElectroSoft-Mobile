import '../../domain/entities/shopping.dart';

class ComprasMock {
  static final List<Compra> compras = [
    Compra(
      id: '001',
      proveedor: 'ElectroSuministros S.A.',
      fecha: DateTime(2026, 4, 8),
      total: 234500,
      estado: EstadoCompra.activa,
      items: [
        const ItemCompra(
          productoId: '1',
          productoNombre: 'Cable THW Cal.12 (100m)',
          cantidad: 10,
          precioUnitario: 12000,
        ),
        const ItemCompra(
          productoId: '2',
          productoNombre: 'Foco LED 12W Alta Potencia',
          cantidad: 5,
          precioUnitario: 15000,
        ),
        const ItemCompra(
          productoId: '3',
          productoNombre: 'Multímetro Digital Pro',
          cantidad: 2,
          precioUnitario: 55000,
        ),
      ],
    ),
    Compra(
      id: '002',
      proveedor: 'CableCenter',
      fecha: DateTime(2026, 4, 5),
      total: 450000,
      estado: EstadoCompra.activa,
      items: [
        const ItemCompra(
          productoId: '4',
          productoNombre: 'Cable THHN Cal.10 Negro',
          cantidad: 20,
          precioUnitario: 95000,
        ),
        const ItemCompra(
          productoId: '5',
          productoNombre: 'Cable Coaxial RG-6 (50m)',
          cantidad: 15,
          precioUnitario: 42000,
        ),
        const ItemCompra(
          productoId: '6',
          productoNombre: 'Cable THW Cal.12 (100m)',
          cantidad: 5,
          precioUnitario: 12000,
        ),
      ],
    ),
    Compra(
      id: '003',
      proveedor: 'Iluminación Total',
      fecha: DateTime(2026, 4, 3),
      total: 89900,
      estado: EstadoCompra.anulada,
      items: [
        const ItemCompra(
          productoId: '7',
          productoNombre: 'Panel LED Inteligente RGB',
          cantidad: 2,
          precioUnitario: 29000,
        ),
        const ItemCompra(
          productoId: '8',
          productoNombre: 'Tira LED 5mts Bluetooth',
          cantidad: 3,
          precioUnitario: 18000,
        ),
      ],
    ),
    Compra(
      id: '004',
      proveedor: 'Herramientas Profesionales SAS',
      fecha: DateTime(2026, 4, 1),
      total: 125000,
      estado: EstadoCompra.activa,
      items: [
        const ItemCompra(
          productoId: '9',
          productoNombre: 'Destornillador Aislado 1000V',
          cantidad: 10,
          precioUnitario: 14000,
        ),
        const ItemCompra(
          productoId: '10',
          productoNombre: 'Pinzas de Corte Diagonales',
          cantidad: 8,
          precioUnitario: 8500,
        ),
      ],
    ),
  ];

  static List<Compra> getCompras() {
    return compras;
  }

  static Compra? getCompraById(String id) {
    try {
      return compras.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}