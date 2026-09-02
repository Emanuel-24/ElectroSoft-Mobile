import 'package:flutter/material.dart';
import '../../domain/entities/client.dart';
import '../widgets/client_detail_widgets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/entities/auth_response.dart';
import 'package:intl/intl.dart';

class ClienteDetalleScreen extends StatelessWidget {
  final Cliente cliente;
  final UserSession usuarioLogueado;

  const ClienteDetalleScreen({
    super.key,
    required this.cliente,
    required this.usuarioLogueado,
  });

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        title: const Text('Detalle de Cliente'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  BigAvatar(
                    avatarUrl: '',
                    avatarLetter: cliente.avatarLetter,
                    avatarColor: cliente.avatarColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    cliente.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClientTypeChip(typeName: cliente.documentType),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información General',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    items: [
                      InfoItem(
                        icon: Icons.badge_outlined,
                        label: 'Tipo de documento',
                        value: cliente.documentType,
                      ),
                      InfoItem(
                        icon: Icons.credit_card_rounded,
                        label: 'Número de identificación',
                        value: cliente.documentNumber,
                      ),
                      InfoItem(
                        icon: Icons.email_outlined,
                        label: 'Correo electrónico',
                        value: cliente.email,
                      ),
                      InfoItem(
                        icon: Icons.phone_android_outlined,
                        label: 'Número de teléfono',
                        value: cliente.phone.isEmpty ? 'No registrado' : cliente.phone,
                      ),
                      InfoItem(
                        icon: Icons.credit_card,
                        label: 'Cupo asignado',
                        value: _formatearPrecio(cliente.cupoTotal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
