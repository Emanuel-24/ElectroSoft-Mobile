import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'products_screen.dart';

class CatProductosScreen extends StatefulWidget {
  const CatProductosScreen({super.key});

  @override
  State<CatProductosScreen> createState() => _CatProductosScreenState();
}

class _CatProductosScreenState extends State<CatProductosScreen> {
  String _query = '';

  static const List<_Categoria> _categorias = [
    _Categoria(nombre: 'Cables', cantidad: 24, icono: Icons.cable_rounded),
    _Categoria(nombre: 'Iluminación', cantidad: 45, icono: Icons.light_rounded),
    _Categoria(
      nombre: 'Herramientas',
      cantidad: 18,
      icono: Icons.construction_rounded,
    ),
    _Categoria(
      nombre: 'Protección',
      cantidad: 32,
      icono: Icons.shield_outlined,
    ),
    _Categoria(
      nombre: 'Interruptores',
      cantidad: 15,
      icono: Icons.toggle_on_rounded,
    ),
    _Categoria(nombre: 'Motores', cantidad: 10, icono: Icons.settings_rounded),
  ];

  List<_Categoria> get _filtradas {
    if (_query.trim().isEmpty) return _categorias;
    final q = _query.toLowerCase();
    return _categorias
        .where((c) => c.nombre.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
        child: GridView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: _filtradas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return _CategoriaCard(
              categoria: _filtradas[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProductosScreen(categoria: _filtradas[index].nombre),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  final _Categoria categoria;
  final VoidCallback onTap;

  const _CategoriaCard({required this.categoria, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 162,
                height: 106,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(categoria.icono, color: AppTheme.primary, size: 48),
              ),
              const Spacer(),
              Text(
                categoria.nombre,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${categoria.cantidad} productos',
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Categoria {
  final String nombre;
  final int cantidad;
  final IconData icono;

  const _Categoria({
    required this.nombre,
    required this.cantidad,
    required this.icono,
  });
}
