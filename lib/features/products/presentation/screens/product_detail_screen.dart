import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatelessWidget {
  final Producto producto;

  const ProductDetailScreen({super.key, required this.producto});

  String _formatearPrecio(double precio) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatCurrency.format(precio);
  }

  Color _obtenerColorStock(int stock) {
    if (stock <= 10) return Colors.redAccent;
    if (stock <= 25) return Colors.orange;
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Detalle de Producto'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con fondo del mismo color que AppBar
            Container(
              width: double.infinity,
              color: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Text(
                    producto.nombre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      producto.categoria.toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Información General (formato lista vertical, sin fondo gris)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'INFORMACIÓN GENERAL',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Divider(height: 24, thickness: 1),
                      
                      // Lista vertical SIN fondo gris
                      _buildInfoRow(
                        label: 'Precio',
                        value: _formatearPrecio(producto.precio),
                      ),
                      const Divider(height: 1, thickness: 1),
                      _buildInfoRow(
                        label: 'Stock',
                        value: '${producto.stock} unidades',
                        valueColor: _obtenerColorStock(producto.stock),
                      ),
                      const Divider(height: 1, thickness: 1),
                      _buildInfoRow(
                        label: 'Serial',
                        value: producto.serial.isEmpty ? 'No registrado' : producto.serial,
                      ),
                      const Divider(height: 1, thickness: 1),
                      _buildInfoRow(
                        label: 'Garantía',
                        value: producto.garantia.isEmpty ? 'No especificada' : producto.garantia,
                      ),
                      const Divider(height: 1, thickness: 1),
                      _buildInfoRow(
                        label: 'Categoría',
                        value: producto.categoria,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Características Técnicas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CARACTERÍSTICAS TÉCNICAS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Divider(height: 24, thickness: 1),
                      
                      producto.caracteristicas.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Text(
                                  'No hay características técnicas registradas',
                                  style: TextStyle(color: AppTheme.textMuted),
                                ),
                              ),
                            )
                          : _buildCaracteristicasTable(),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, size: 20),
        label: const Text('Volver'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Widget para fila de información (estilo lista, sin fondo gris)
  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaracteristicasTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        columnWidths: const {
          0: FixedColumnWidth(140),
          1: FixedColumnWidth(100),
          2: FixedColumnWidth(160),
        },
        children: [
          // Encabezado
          TableRow(
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
            ),
            children: [
              _buildTableCell('Característica', isHeader: true),
              _buildTableCell('Medida', isHeader: true),
              _buildTableCell('Valor', isHeader: true),
            ],
          ),
          // Filas de características
          ...producto.caracteristicas.map((caract) => TableRow(
                children: [
                  _buildTableCell(caract.caracteristica),
                  _buildTableCell(caract.medida.isEmpty ? '-' : caract.medida),
                  _buildTableCell(caract.valor),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? AppTheme.primary : AppTheme.textDark,
        ),
      ),
    );
  }
}