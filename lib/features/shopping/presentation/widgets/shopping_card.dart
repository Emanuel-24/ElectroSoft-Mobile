import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/shopping.dart';
import '../screens/shopping_detail_screen.dart';

class CompraCard extends StatelessWidget {
  final Shopping compra;

  const CompraCard({super.key, required this.compra});

  String _formatearPrecio(double precio) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatCurrency.format(precio);
  }

  String _obtenerFecha() {
    if (compra.purchaseDate != null && compra.purchaseDate!.isNotEmpty) {
      return compra.purchaseDate!;
    }
    return DateFormat('dd/MM/yyyy').format(compra.createdAt);
  }

  Color _obtenerColorEstado(String estado) {
    switch (estado.toUpperCase()) {
      case 'ACTIVA':
        return AppTheme.verde;
      case 'ANULADA':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color estadoColor = _obtenerColorEstado(compra.estado);
    final int cantidadItems = compra.products.length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleCompraScreen(compra: compra),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'FACTURA #${compra.invoiceNumber}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: estadoColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      compra.estado.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: estadoColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                compra.providerName ?? 'Proveedor desconocido',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _obtenerFecha(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatearPrecio(compra.total),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'PRODUCTOS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$cantidadItems items',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}