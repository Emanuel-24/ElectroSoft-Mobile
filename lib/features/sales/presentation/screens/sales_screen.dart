import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/entities/auth_response.dart';
import '../../data/services/sales_service.dart';
import '../../data/models/sales_model.dart';
import '../widgets/sales_card.dart';

class VentasScreen extends StatefulWidget {
  final String searchQuery;
  final UserSession usuario;

  const VentasScreen({
    super.key, 
    this.searchQuery = '',
    required this.usuario,
  });

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final SalesService _salesService = SalesService();
  late Future<List<SaleModel>> _futureVentas;

  String _normalizarTexto(String texto) {
    // Convierte a minúsculas y remueve acentos
    return texto
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n');
  }

  @override
  void initState() {
    super.initState();
    _cargarVentas();
  }

  void _cargarVentas() {
    setState(() {
      _futureVentas = _salesService.obtenerVentas();
    });
  }

  List<SaleModel> _filtrarVentas(List<SaleModel> lista) {
    if (widget.searchQuery.trim().isEmpty) return lista;
    final q = widget.searchQuery.trim().toLowerCase();
    final qNormalizado = _normalizarTexto(q);
    final qSinSeparadores = q.replaceAll(RegExp(r'[^0-9]'), '');
    final currencyFormat = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    
    return lista.where((v) {
      final facturaNumNormalizada = _normalizarTexto(v.numeroFactura);
      final matchesInvoice = facturaNumNormalizada.contains(qNormalizado) || 
          v.numeroFactura.toLowerCase().contains(q);
      
      final clienteNormalizado = _normalizarTexto(v.clienteName ?? '');
      final matchesClient = clienteNormalizado.contains(qNormalizado);
      
      final fecha = v.fechaVenta != null && v.fechaVenta!.isNotEmpty
          ? v.fechaVenta!
          : DateFormat('dd/MM/yyyy').format(v.fechaCreacion);
      final matchesDate = fecha.toLowerCase().contains(q);
      final totalFormateado = currencyFormat.format(v.total).toLowerCase();
      final totalNumerico = v.total.round().toString();
      final matchesTotal = totalFormateado.contains(q) ||
          (qSinSeparadores.isNotEmpty && totalNumerico.contains(qSinSeparadores));
      return matchesInvoice || matchesClient || matchesDate || matchesTotal;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: FutureBuilder<List<SaleModel>>(
        future: _futureVentas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  Text(
                    'Error al cargar ventas',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: _cargarVentas,
                    child: const Text('Reintentar', style: TextStyle(color: AppTheme.primary)),
                  )
                ],
              ),
            );
          }

          final listaReal = snapshot.data ?? [];
          final ventas = _filtrarVentas(listaReal);

          if (ventas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'No se encontraron ventas',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ventas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return VentaCard(venta: ventas[index]);
            },
          );
        },
      ),
    );
  }
}
