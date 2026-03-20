import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class _Producto {
  final String sku;
  final String nombre;
  final String categoria;
  final int stock;
  final double precio;

  const _Producto({
    required this.sku,
    required this.nombre,
    required this.categoria,
    required this.stock,
    required this.precio,
  });
}

const Map<String, List<_Producto>> _productosPorCategoria = {
  'Iluminación': [
    _Producto(sku: 'EL-001', nombre: 'Foco LED 12W Alta Potencia',  categoria: 'Iluminación', stock: 50, precio: 15.00),
    _Producto(sku: 'EL-042', nombre: 'Lámpara Industrial de Techo', categoria: 'Iluminación', stock: 12, precio: 45.99),
    _Producto(sku: 'EL-089', nombre: 'Panel LED Inteligente RGB',   categoria: 'Iluminación', stock: 5,  precio: 29.50),
    _Producto(sku: 'EL-112', nombre: 'Reflector Exterior 50W',      categoria: 'Iluminación', stock: 24, precio: 38.00),
    _Producto(sku: 'EL-205', nombre: 'Tira LED 5mts Bluetooth',     categoria: 'Iluminación', stock: 15, precio: 18.90),
  ],
  'Cables': [
    _Producto(sku: 'CA-001', nombre: 'Cable THW Cal.12 (100m)',  categoria: 'Cables', stock: 8,  precio: 120.00),
    _Producto(sku: 'CA-045', nombre: 'Cable THHN Cal.10 Negro',  categoria: 'Cables', stock: 20, precio: 95.00),
    _Producto(sku: 'CA-088', nombre: 'Cable Coaxial RG-6 (50m)', categoria: 'Cables', stock: 35, precio: 42.00),
  ],
  'Herramientas': [
    _Producto(sku: 'HE-001', nombre: 'Multímetro Digital Pro',       categoria: 'Herramientas', stock: 7,  precio: 55.00),
    _Producto(sku: 'HE-033', nombre: 'Pinzas de Corte Diagonales',   categoria: 'Herramientas', stock: 40, precio: 8.50),
    _Producto(sku: 'HE-077', nombre: 'Destornillador Aislado 1000V', categoria: 'Herramientas', stock: 25, precio: 14.00),
  ],
  'Protección': [
    _Producto(sku: 'PR-001', nombre: 'Breaker 2x20A Siemens',        categoria: 'Protección', stock: 60, precio: 18.50),
    _Producto(sku: 'PR-040', nombre: 'Caja Nema Metálica 30x30',     categoria: 'Protección', stock: 15, precio: 32.00),
    _Producto(sku: 'PR-088', nombre: 'Tablero 12 Circuitos Empotr.', categoria: 'Protección', stock: 10, precio: 78.00),
  ],
  'Interruptores': [
    _Producto(sku: 'IN-001', nombre: 'Apagador Simple Bticino',   categoria: 'Interruptores', stock: 80, precio: 6.50),
    _Producto(sku: 'IN-050', nombre: 'Apagador Doble con LED',    categoria: 'Interruptores', stock: 45, precio: 12.00),
    _Producto(sku: 'IN-099', nombre: 'Apagador Inteligente WiFi', categoria: 'Interruptores', stock: 9,  precio: 22.50),
  ],
  'Motores': [
    _Producto(sku: 'MO-001', nombre: 'Motor Monofásico 1/2 HP',    categoria: 'Motores', stock: 5, precio: 210.00),
    _Producto(sku: 'MO-030', nombre: 'Motor Trifásico 1 HP',       categoria: 'Motores', stock: 3, precio: 380.00),
    _Producto(sku: 'MO-060', nombre: 'Variador de Frecuencia 2HP', categoria: 'Motores', stock: 7, precio: 145.00),
  ],
};

class ProductosScreen extends StatefulWidget {
  final String categoria;
  const ProductosScreen({super.key, required this.categoria});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  String _query = '';
  final _ctrl = TextEditingController();

  List<_Producto> get _todos => _productosPorCategoria[widget.categoria] ?? [];

  List<_Producto> get _filtrados {
    if (_query.trim().isEmpty) return _todos;
    final q = _query.toLowerCase();
    return _todos
        .where((p) =>
            p.nombre.toLowerCase().contains(q) ||
            p.sku.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productos = _filtrados;

    return Scaffold(
      // ── Fondo blanco, no gris ──
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(108),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 4,
            left: 4,
            right: 16,
            bottom: 10,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      color: AppTheme.textDark,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.categoria,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz_rounded, size: 22),
                      color: AppTheme.textDark,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // ── Buscador: más border radius + lupa amarilla ──
              Container(
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24), // ← más redondeado
                ),
                child: TextField(
                  controller: _ctrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
                  decoration: InputDecoration(
                    hintText: 'Buscar productos...',
                    hintStyle: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
                    // ── Lupa amarilla ──
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppTheme.primary, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _ctrl.clear();
                              setState(() => _query = '');
                            },
                            child: const Icon(Icons.close_rounded,
                                color: AppTheme.textMuted, size: 18),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: ElectroBottomNav(
        items: ElectroNavItem.defaults(),
        initialIndex: 3,
        onTabChanged: (_) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${productos.length} RESULTADOS ENCONTRADOS',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMuted,
                    letterSpacing: 0.4,
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.tune_rounded, size: 18, color: AppTheme.textMuted),
                    SizedBox(width: 10),
                    Icon(Icons.swap_vert_rounded, size: 18, color: AppTheme.textMuted),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: productos.isEmpty
                ? _EstadoVacio(query: _query)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: productos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _ProductoCard(producto: productos[i]),
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppTheme.textDark, size: 28),
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final _Producto producto;
  const _ProductoCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: AppTheme.primary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Nombre categoría en amarillo ──
                      Text(
                        producto.categoria.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary, // ← amarillo
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        producto.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('SKU: ${producto.sku}',
                              style: const TextStyle(
                                  fontSize: 12, color: AppTheme.textMuted)),
                          const SizedBox(width: 14),
                          const Text('Stock: ',
                              style: TextStyle(
                                  fontSize: 12, color: AppTheme.textMuted)),
                          Text('${producto.stock} unidades',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4CAF50),
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '\$${producto.precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  final String query;
  const _EstadoVacio({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 64, color: Color(0xFFD0D0D0)),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'No hay productos' : 'Sin resultados para\n"$query"',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}