import 'package:electrosoft/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/auth_response.dart';
import '../../features/products/presentation/screens/cat_products_screen.dart';
import '../../features/shopping/presentation/screens/shopping_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../../features/users/domain/entities/user.dart';
import '../widgets/widgets.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  final UserSession usuario;

  const MainShell({super.key, this.initialIndex = 0, required this.usuario});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  static const List<_PageConfig> _pages = [
    _PageConfig(title: '', showSearch: false),
    _PageConfig(title: 'Usuarios', searchHint: 'Buscar usuario...'),
    _PageConfig(title: 'Compras', searchHint: 'Buscar compra...'),
    _PageConfig(
      title: 'Categorías de productos',
      searchHint: 'Buscar categoría...',
    ),
    _PageConfig(title: '', showSearch: false),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPage = _pages[_currentIndex];

    return Scaffold(
      appBar: ElectroAppBar(
        title: currentPage.title,
        showSearch: currentPage.showSearch,
        searchHint: currentPage.searchHint,
        onSearch: (value) => setState(() => _searchQuery = value),
        avatarUrl: '',
        onAvatarTap: () {
          setState(() => _currentIndex = 4);
        },
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: ElectroBottomNav(
        items: ElectroNavItem.defaults(),
        initialIndex: _currentIndex,
        onTabChanged: (index) => setState(() {
          _currentIndex = index;
          _searchQuery = '';
        }),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return UsuariosScreen(
          searchQuery: _searchQuery,
          usuario: widget.usuario,
        );
      case 2:
        return ComprasScreen(searchQuery: _searchQuery);
      case 3:
        return CatProductosScreen(
          searchQuery: _searchQuery,
          usuario: widget.usuario,
        );
      case 4:
        return EditProfileScreen(
          profile: Usuario(
            id: widget.usuario.id,
            fullName: widget.usuario.fullName,
            email: widget.usuario.email,
            phone: widget.usuario.phone,
            documentNumber: widget.usuario.documentNumber,
            documentAbbreviation: 'CC',
            roleName: widget.usuario.role,
            isActive: widget.usuario.isActive,
            lastAccess: DateTime.now().toIso8601String(),
          ),
          onProfileUpdated: () {
            debugPrint(
              "Perfil actualizado en el backend, recargando contenedor...",
            );
          },
        );
      default:
        return const SizedBox();
    }
  }
}

class _PageConfig {
  final String title;
  final String searchHint;
  final bool showSearch;

  const _PageConfig({
    required this.title,
    this.searchHint = 'Buscar...',
    this.showSearch = true,
  });
}