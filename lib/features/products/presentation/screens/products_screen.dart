import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart'; // Tu BottomNav y otros compartidos
import '../../domain/entities/product.dart'; // Clase Producto
import '../../data/data_sources/products_mock.dart'; // Clase ProductosMock
import '../widgets/product_card.dart'; // Clase ProductoCard y EstadoVacio

class ProductosScreen extends StatefulWidget {
  final String categoria;

  const ProductosScreen({super.key, required this.categoria});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  String _query = '';
  final TextEditingController _ctrl = TextEditingController();

  // Obtenemos los productos de la categoría seleccionada desde el Mock
  List<Producto> get _todos =>
      ProductosMock.porCategoria[widget.categoria] ?? [];

  // Aplicamos el filtro de búsqueda por Nombre o SKU
  List<Producto> get _filtrados {
    if (_query.trim().isEmpty) return _todos;
    final q = _query.toLowerCase();
    return _todos.where((p) => p.nombre.toLowerCase().contains(q)).toList();
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
      backgroundColor: Colors.white,
      // Usamos PreferredSize para un AppBar personalizado con buscador
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: _ProductosAppBar(
          titulo: widget.categoria,
          controller: _ctrl,
          onChanged: (v) => setState(() => _query = v),
          onClear: () {
            _ctrl.clear();
            setState(() => _query = '');
          },
          showClear: _query.isNotEmpty,
        ),
      ),

      // BottomNav para mantener la navegación global
      bottomNavigationBar: ElectroBottomNav(
        items: ElectroNavItem.defaults(),
        initialIndex: 3, // Asumiendo que el índice 3 es Inventario/Productos
        onTabChanged: (_) {
          // Limpia la pila para volver al inicio del Tab al cambiar
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contador de resultados
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              '${productos.length} RESULTADOS ENCONTRADOS',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Lista de productos o Estado Vacío
          Expanded(
            child: productos.isEmpty
                ? EstadoVacio(query: _query)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                    itemCount: productos.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return ProductoCard(producto: productos[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- Widget Privado para el AppBar de esta pantalla ---
class _ProductosAppBar extends StatelessWidget {
  final String titulo;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showClear;

  const _ProductosAppBar({
    required this.titulo,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.showClear,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(8, topPadding + 4, 16, 12),
      child: Column(
        children: [
          // Fila Superior: Botón Atrás + Título
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                color: AppTheme.textDark,
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Espaciador para centrar el título
            ],
          ),
          const SizedBox(height: 8),
          // Buscador Redondeado
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(22),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o SKU...',
                hintStyle: const TextStyle(color: AppTheme.textMuted),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppTheme.primary,
                  size: 20,
                ),
                suffixIcon: showClear
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: onClear,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
