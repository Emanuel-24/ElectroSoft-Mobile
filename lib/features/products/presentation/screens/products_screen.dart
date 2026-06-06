import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_card.dart';
import '../../../../shared/widgets/main_shell.dart';
import '../../data/services/product_service.dart';
import '../../../auth/domain/entities/auth_response.dart';

class ProductosScreen extends StatefulWidget {
  final String categoria;
  final UserSession usuario;

  const ProductosScreen({
    super.key,
    required this.categoria,
    required this.usuario,
  });

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  String _query = '';
  final TextEditingController _ctrl = TextEditingController();
  final ProductService _service = ProductService();

  List<Product> _todosLosProductos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _cargarProductosDelBackend();
  }

  Future<void> _cargarProductosDelBackend() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final productosApi = await _service.obtenerProductos();

      _todosLosProductos = productosApi
          .where(
            (p) =>
                p.categoryName.trim().toLowerCase() ==
                widget.categoria.trim().toLowerCase(),
          )
          .toList();
    } catch (e) {
      _errorMessage = 'Error al conectar con el servidor';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Product> get _filtrados {
    if (_query.trim().isEmpty) return _todosLosProductos;
    final q = _query.toLowerCase();
    return _todosLosProductos
        .where((p) => p.name.toLowerCase().contains(q))
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
      backgroundColor: Colors.white,
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

      bottomNavigationBar: ElectroBottomNav(
        items: ElectroNavItem.defaults(),
        initialIndex: 3,
        onTabChanged: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MainShell(
                initialIndex: index,
                usuario: widget.usuario,
              ),
            ),
          );
        },
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _cargarProductosDelBackend,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            )
          else ...[
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
        ],
      ),
    );
  }
}

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
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
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
                hintText: 'Buscar por nombre',
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