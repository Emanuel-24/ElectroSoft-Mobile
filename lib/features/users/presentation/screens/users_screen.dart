import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../data/services/user_service.dart';
import '../widgets/user_cards.dart';
import 'user_detail_screen.dart';
import '../../../auth/domain/entities/auth_response.dart';

class UsuariosScreen extends StatefulWidget {
  final String searchQuery;
  final UserSession usuario;

  const UsuariosScreen({
    super.key,
    this.searchQuery = '',
    required this.usuario,
  });

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final UserService _userService = UserService();
  late Future<List<Usuario>> _futureUsuarios;

  @override
  void initState() {
    super.initState();
    _futureUsuarios = _userService.obtenerUsuarios();
  }

  List<Usuario> _filtrarUsuarios(List<Usuario> lista) {
    if (widget.searchQuery.isEmpty) return lista;
    final q = widget.searchQuery.toLowerCase();
    return lista.where((u) {
      return u.fullName.toLowerCase().contains(q) ||
          u.roleName.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _futureUsuarios,
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
        final filtrados = _filtrarUsuarios(listaReal);

        if (filtrados.isEmpty) {
          return const Center(child: Text('No se encontraron usuarios'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtrados.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final usuario = filtrados[index];

            return UsuarioCard(
              usuario: usuario,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsuarioDetalleScreen(
                      usuario: usuario,
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