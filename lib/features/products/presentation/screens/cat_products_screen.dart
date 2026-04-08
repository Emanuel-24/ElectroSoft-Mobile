import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../data/data_sources/categories_mock.dart';
import '../widgets/category_card.dart';
import 'products_screen.dart';

class CatProductosScreen extends StatelessWidget {
  final String searchQuery;
  const CatProductosScreen({super.key, this.searchQuery = ''});

  List<Categoria> get _filtradas {
    final categorias = CategoriasMock.listado;
    if (searchQuery.trim().isEmpty) return categorias;
    final q = searchQuery.toLowerCase();
    return categorias.where((c) => c.nombre.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Nota: Quitamos el Scaffold si esta pantalla ya vive dentro de un TabView o MainLayout
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GridView.builder(
        itemCount: _filtradas.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final categoria = _filtradas[index];
          return CategoriaCard(
            categoria: categoria,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductosScreen(categoria: categoria.nombre),
              ),
            ),
          );
        },
      ),
    );
  }
}
