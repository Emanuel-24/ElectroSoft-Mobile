import 'package:electrosoft/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/auth_response.dart';
import '../../core/constants/app_config.dart';
import '../../features/products/presentation/screens/cat_products_screen.dart';
import '../../features/shopping/presentation/screens/shopping_screen.dart';
import '../../features/sales/presentation/screens/sales_screen.dart';
import '../../features/clients/presentation/screens/clients_screen.dart';
import '../../features/profile/data/services/profile_service.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
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
  late String _avatarLetter;
  late String _avatarColor;
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _avatarLetter = widget.usuario.avatarLetter;
    _avatarColor = widget.usuario.avatarColor;
  }

  static const List<_PageConfig> _pages = [
    _PageConfig(title: '', showSearch: false),
    _PageConfig(title: 'Ventas', searchHint: 'Buscar venta...'),
    _PageConfig(title: 'Compras', searchHint: 'Buscar compra...'),
    _PageConfig(
      title: 'Categorías de productos',
      searchHint: 'Buscar categoría...',
    ),
    _PageConfig(title: 'Clientes', searchHint: 'Buscar cliente...'),
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
        avatarUrl: widget.usuario.avatar,
        avatarLetter: _avatarLetter,
        avatarColor: _avatarColor,
        canEditProfile: !AppConfig.isGlobalAdmin(widget.usuario.email),
        onAvatarTap: () async {
          try {
            final profile = await _profileService.obtenerPerfilActual(
              widget.usuario.id,
            );
            if (!context.mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EditProfileScreen(
                  profile: profile,
                  onProfileUpdated: (letter, color) {
                    setState(() {
                      _avatarLetter = letter;
                      _avatarColor = color;
                    });
                  },
                ),
              ),
            );
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se pudo abrir el perfil: $e')),
            );
          }
        },
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: ElectroBottomNav(
        items: ElectroNavItem.defaults(),
        initialIndex: _currentIndex,
        onTabChanged: (index) {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _currentIndex = index;
            _searchQuery = '';
          });
        },
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return VentasScreen(
          searchQuery: _searchQuery,
          usuario: widget.usuario,
        );
      case 2:
        return ComprasScreen(
          searchQuery: _searchQuery,
          usuario: widget.usuario,
        );
      case 3:
        return CatProductosScreen(
          searchQuery: _searchQuery,
          usuario: widget.usuario,
        );
      case 4:
        return ClientesScreen(
          searchQuery: _searchQuery,
          usuario: widget.usuario,
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
