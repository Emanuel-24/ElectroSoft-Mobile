import 'package:flutter/material.dart';
import '../../data/services/categoria_service.dart';
import '../../domain/entities/category.dart';
import '../widgets/category_card.dart';
import 'products_screen.dart';
import '../../../auth/domain/entities/auth_response.dart';

class CatProductosScreen extends StatefulWidget {
  final String searchQuery;
  final UserSession usuario;

  const CatProductosScreen({
    super.key,
    this.searchQuery = '',
    required this.usuario,
  });

  @override
  State<CatProductosScreen> createState() => _CatProductosScreenState();
}

class _CatProductosScreenState extends State<CatProductosScreen> {
  final CategoriaService _service = CategoriaService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _service.obtenerCategorias(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final categorias = snapshot.data ?? [];

        final filtradas = widget.searchQuery.trim().isEmpty
            ? categorias
            : categorias.where((c) {
                return c.name.toLowerCase().contains(
                  widget.searchQuery.toLowerCase(),
                );
              }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: GridView.builder(
            itemCount: filtradas.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final category = filtradas[index];

              return CategoriaCard(
                category: category,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductosScreen(
                      categoria: category.name,
                      usuario: widget.usuario,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
