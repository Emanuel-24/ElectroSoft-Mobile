import 'package:flutter/material.dart';
import '../../domain/entities/product.dart'; // ← Asegúrate de que apunte a tu entidad final 'Product'
import '../../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import '../screens/product_detail_screen.dart'; 

class ProductoCard extends StatelessWidget {
  final Product producto; // ← Cambiado de 'Producto' a 'Product'
  
  const ProductoCard({super.key, required this.producto});

  // Lógica para el color del stock (se mantiene intacta)
  Color _obtenerColorStock(int stock) {
    if (stock <= 10) return Colors.redAccent;
    if (stock <= 25) return Colors.orange;
    return const Color(0xFF4CAF50);
  }

  // Lógica para formato de moneda (es_CO) (se mantiene intacta)
  String _formatearPrecio(double precio) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatCurrency.format(precio);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(  
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(producto: producto),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
                // Barra lateral indicadora de stock crítico
                Container(
                  width: 4,
                  color: producto.stock <= 10 ? Colors.redAccent : AppTheme.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Categoría (Adaptado de producto.categoria a producto.categoryName)
                        Text(
                          producto.categoryName.toUpperCase(), 
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // Nombre (Adaptado de producto.nombre a producto.name)
                        Text(
                          producto.name, 
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
                            const Text(
                              'Stock: ',
                              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                            ),
                            Text(
                              '${producto.stock} uds',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _obtenerColorStock(producto.stock),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            // Precio (Mantiene producto.price)
                            _formatearPrecio(producto.price),
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
      ),
    );
  }
}

class EstadoVacio extends StatelessWidget {
  final String query;
  const EstadoVacio({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Color(0xFFD0D0D0),
          ),
          const SizedBox(height: 16),
          Text(
            query.isEmpty
                ? 'No hay productos'
                : 'Sin resultados para\n"$query"',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}