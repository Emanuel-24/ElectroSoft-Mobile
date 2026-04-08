import 'package:flutter/material.dart';
import '../../domain/entities/role.dart';
import '../../data/data_sources/roles_mock.dart';
import '../widgets/role_card.dart';

class RolesScreen extends StatelessWidget {
  final String searchQuery;
  const RolesScreen({super.key, this.searchQuery = ''});

  List<Rol> get _filtrados {
    final roles = RolesMock.listado;
    if (searchQuery.isEmpty) return roles;
    final q = searchQuery.toLowerCase();
    return roles
        .where(
          (r) =>
              r.title.toLowerCase().contains(q) ||
              r.description.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filtrados.length,
      itemBuilder: (context, index) {
        return RoleCard(rol: _filtrados[index]);
      },
    );
  }
}
