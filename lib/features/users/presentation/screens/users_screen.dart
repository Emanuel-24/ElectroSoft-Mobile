import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../data/data_sources/users_mock.dart';
import '../widgets/user_cards.dart';
import 'user_detail_screen.dart';

class UsuariosScreen extends StatelessWidget {
  final String searchQuery;
  const UsuariosScreen({super.key, this.searchQuery = ''});

  List<Usuario> get _filtrados {
    final usuarios = UsuariosMock.listado;
    if (searchQuery.isEmpty) return usuarios;
    final q = searchQuery.toLowerCase();
    return usuarios
        .where(
          (u) =>
              u.nombre.toLowerCase().contains(q) ||
              u.rol.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filtrados.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final usuario = _filtrados[index];

        return UsuarioCard(
          usuario: usuario,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsuarioDetalleScreen(usuario: usuario),
            ),
          ),
        );
      },
    );
  }
}
