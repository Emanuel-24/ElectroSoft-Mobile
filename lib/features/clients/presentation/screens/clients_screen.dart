import 'package:flutter/material.dart';
import '../../domain/entities/client.dart';
import '../../data/services/client_service.dart';
import '../widgets/client_cards.dart';
import 'client_detail_screen.dart';
import '../../../auth/domain/entities/auth_response.dart';

class ClientesScreen extends StatefulWidget {
  final String searchQuery;
  final UserSession usuario;

  const ClientesScreen({
    super.key,
    this.searchQuery = '',
    required this.usuario,
  });

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ClientService _clientService = ClientService();
  late Future<List<Cliente>> _futureClientes;

  String _normalizarTexto(String texto) {
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
    _futureClientes = _clientService.obtenerClientes();
  }

  List<Cliente> _filtrarClientes(List<Cliente> lista) {
    if (widget.searchQuery.isEmpty) return lista;
    final q = widget.searchQuery.toLowerCase();
    final qNormalizado = _normalizarTexto(q);
    return lista.where((c) {
      final nombreNormalizado = _normalizarTexto(c.fullName);
      final tipoDocNormalizado = _normalizarTexto(c.documentType);
      return nombreNormalizado.contains(qNormalizado) ||
          tipoDocNormalizado.contains(qNormalizado) ||
          c.fullName.toLowerCase().contains(q) ||
          c.documentType.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cliente>>(
      future: _futureClientes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFFD54F)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Ocurrió un error: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }

        final listaReal = snapshot.data ?? [];
        final filtrados = _filtrarClientes(listaReal);

        if (filtrados.isEmpty) {
          return const Center(child: Text('No se encontraron clientes'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtrados.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final cliente = filtrados[index];

            return ClienteCard(
              cliente: cliente,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClienteDetalleScreen(
                      cliente: cliente,
                      usuarioLogueado: widget.usuario,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
