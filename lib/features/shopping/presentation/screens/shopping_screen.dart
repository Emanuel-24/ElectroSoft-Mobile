import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/entities/auth_response.dart';
import '../../data/services/shopping_service.dart';
import '../../domain/entities/shopping.dart';
import '../widgets/shopping_card.dart';

class ComprasScreen extends StatefulWidget {
  final String searchQuery;
  final UserSession usuario;

  const ComprasScreen({
    super.key, 
    this.searchQuery = '',
    required this.usuario,
  });

  @override
  State<ComprasScreen> createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
  final ShoppingService _shoppingService = ShoppingService();
  late Future<List<Shopping>> _futureCompras;

  @override
  void initState() {
    super.initState();
    _cargarCompras();
  }

  void _cargarCompras() {
    setState(() {
      _futureCompras = _shoppingService.obtenerCompras();
    });
  }

  List<Shopping> _filtrarCompras(List<Shopping> lista) {
    if (widget.searchQuery.trim().isEmpty) return lista;
    final q = widget.searchQuery.toLowerCase();
    
    return lista.where((c) {
      final matchesInvoice = c.invoiceNumber.toLowerCase().contains(q);
      final matchesProvider = c.providerName?.toLowerCase().contains(q) ?? false;
      return matchesInvoice || matchesProvider;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: FutureBuilder<List<Shopping>>(
        future: _futureCompras,
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
                    'Error al cargar compras',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: _cargarCompras,
                    child: const Text('Reintentar', style: TextStyle(color: AppTheme.primary)),
                  )
                ],
              ),
            );
          }

          final listaReal = snapshot.data ?? [];
          final compras = _filtrarCompras(listaReal);

          if (compras.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay compras registradas',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _cargarCompras(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: compras.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CompraCard(compra: compras[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}