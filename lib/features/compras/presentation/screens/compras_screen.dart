import 'package:electrosoft/features/compras/data/data_sources/compras_mock.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/compra_card.dart';

class ComprasScreen extends StatelessWidget {
  final String? searchQuery;

  const ComprasScreen({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final compras = ComprasMock.getCompras();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: compras.isEmpty
          ? const Center(
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
            )
          : ListView.builder(
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
  }
}