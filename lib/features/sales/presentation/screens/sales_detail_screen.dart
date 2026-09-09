import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/sales_model.dart';
import '../../data/services/sales_service.dart';
import '../../domain/entities/sale.dart';

class DetalleVentaScreen extends StatelessWidget {
  final Sale venta;

  const DetalleVentaScreen({super.key, required this.venta});

  String _formatearPrecio(double precio) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatCurrency.format(precio);
  }

  String _formatearFecha(String? value) {
    if (value == null || value.trim().isEmpty) {
      return DateFormat('dd/MM/yyyy').format(venta.fechaCreacion);
    }

    final texto = value.trim();
    final parsedDate = DateTime.tryParse(texto);
    if (parsedDate != null) {
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    }

    final parsedSlash = DateFormat('dd/MM/yyyy').tryParse(texto);
    if (parsedSlash != null) {
      return DateFormat('dd/MM/yyyy').format(parsedSlash);
    }

    return texto;
  }

  Color _obtenerColorEstado(String estado) {
    final estadoNorm = estado
        .toUpperCase()
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ñ', 'N');
    if (estadoNorm.contains('ANULADA')) return Colors.red;
    if (estadoNorm.contains('FINALIZADO')) return AppTheme.verde;
    if (estadoNorm.contains('DEVUELTO') ||
        estadoNorm.contains('DEVOLUCION PARCIAL')) {
      return Colors.blue;
    }
    return AppTheme.amarillo;
  }

  String _obtenerFecha() {
    return _formatearFecha(venta.fechaVenta);
  }

  String _formatearDocumento(Sale sale) {
    final tipo = sale.clienteTipoDocumento?.trim();
    final documento = sale.clienteDocumento?.trim();

    if (documento == null || documento.isEmpty) {
      return 'No registrado';
    }

    return (tipo == null || tipo.isEmpty) ? documento : '$tipo: $documento';
  }

  bool get _esVentaDevuelta {
    final estado = venta.estado
        .toUpperCase()
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ñ', 'N');
    return estado.contains('DEVUELTO') || estado.contains('DEVOLUCION PARCIAL');
  }

  List<SaleDevolutionProduct> _obtenerProductosDevueltos(
    List<SaleDevolutionModel> devoluciones,
  ) {
    final productos = <SaleDevolutionProduct>[];
    for (final devolucion in devoluciones) {
      productos.addAll(devolucion.productos);
    }
    return productos;
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color estadoColor = _obtenerColorEstado(venta.estado);

    return FutureBuilder<List<SaleDevolutionModel>>(
      future: _esVentaDevuelta
          ? SalesService().obtenerDevolucionesPorVenta(venta.id)
          : Future.value(const []),
      builder: (context, snapshot) {
        final devoluciones = snapshot.hasData
            ? snapshot.data!
            : const <SaleDevolutionModel>[];
        final productosDevueltos = _obtenerProductosDevueltos(devoluciones);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: const Text('Detalle de Venta'),
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: estadoColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            venta.estado.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: estadoColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (venta.isAnulada && venta.infoAnulacion != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      elevation: 2,
                      color: Colors.red.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.shade200, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.report_problem,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'DETALLES DE ANULACIÓN',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 20,
                              thickness: 1,
                              color: Colors.redAccent,
                            ),
                            Text(
                              'Motivo: ${venta.infoAnulacion?.motivo ?? "No especificado"}',
                              style: TextStyle(
                                color: Colors.red.shade900,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

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
                            'INFORMACIÓN DE LA VENTA',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Divider(height: 24, thickness: 1),
                          _buildInfoRow(
                            label: 'Número de factura',
                            value: venta.numeroFactura,
                          ),
                          const Divider(height: 1, thickness: 1),
                          _buildInfoRow(
                            label: 'Cliente',
                            value: venta.clienteName?.trim().isNotEmpty == true
                                ? venta.clienteName!.trim()
                                : 'Sin cliente',
                          ),
                          const Divider(height: 1, thickness: 1),
                          _buildInfoRow(
                            label: 'Documento cliente',
                            value: _formatearDocumento(venta),
                          ),
                          const Divider(height: 1, thickness: 1),
                          _buildInfoRow(label: 'Fecha', value: _obtenerFecha()),
                          const Divider(height: 1, thickness: 1),
                          _buildInfoRow(
                            label: 'Total',
                            value: _formatearPrecio(venta.total),
                            valueColor: AppTheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

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
                            'PRODUCTOS VENDIDOS',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Divider(height: 24, thickness: 1),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: venta.productos.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1, thickness: 1),
                            itemBuilder: (context, index) {
                              final producto = venta.productos[index];
                              final double subtotal =
                                  producto.quantity * producto.precioUnitario;
                              final productLabel =
                                  producto.productName ??
                                  'Producto ID: ${producto.productoId.length > 8 ? producto.productoId.substring(0, 8) : producto.productoId}';

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            productLabel,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${producto.quantity} unds x ${_formatearPrecio(producto.precioUnitario)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _formatearPrecio(subtotal),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Divider(height: 24, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'TOTAL FACTURADO',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              Text(
                                _formatearPrecio(venta.total),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_esVentaDevuelta) ...[
                  const SizedBox(height: 16),
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
                              'PRODUCTOS DEVUELTOS',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Divider(height: 24, thickness: 1),
                            if (productosDevueltos.isEmpty)
                              const Text(
                                'No hay productos devueltos para esta venta.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textMuted,
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: productosDevueltos.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1, thickness: 1),
                                itemBuilder: (context, index) {
                                  final producto = productosDevueltos[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                producto.nombre,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.textDark,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Motivo: ${producto.motivo.isNotEmpty ? producto.motivo : "No especificado"}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppTheme.textMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade50,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            'Cant: ${producto.cantidad}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
