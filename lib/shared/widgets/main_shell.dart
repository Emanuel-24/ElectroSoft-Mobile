import 'package:electrosoft/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

// Importaciones de tus pantallas
import '../../features/products/presentation/screens/cat_products_screen.dart';
import '../../features/shopping/presentation/screens/shopping_screen.dart'; // ← AGREGAR
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../../features/profile/domain/entities/user_profile.dart';
import '../widgets/widgets.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

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

  // Datos del perfil
  UserProfile _userProfile = const UserProfile(
    fullName: 'Andres Camilo Santa',
    email: 'Andrescamilo@gmail.com',
    phone: '3003478277',
    document: '1232598525',
    documentType: 'C.C',
    role: 'Admin',
  );

  // Configuración centralizada de las páginas
  static const List<_PageConfig> _pages = [
    _PageConfig(title: '', showSearch: false),                    // Dashboard (0)
    _PageConfig(title: 'Usuarios', searchHint: 'Buscar usuario...'), // Usuarios (1)    // Roles (2)
    _PageConfig(title: 'Compras', searchHint: 'Buscar compra...'), // Compras (3) ← NUEVO
    _PageConfig(title: 'Categorías de productos', showSearch: false), // Categorías (3) ← NUEVO
    _PageConfig(title: '', showSearch: false),              // Perfil (4)
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
        avatarUrl: _userProfile.avatarUrl,
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
        return UsuariosScreen(searchQuery: _searchQuery);
      case 2:
        return ComprasScreen(searchQuery: _searchQuery);
      case 3:
        return CatProductosScreen(searchQuery: _searchQuery); // ← Categorías de productos
      case 4:
        return EditProfileScreen(
          profile: _userProfile,
          onSave: (updated) => setState(() => _userProfile = updated),
        );
      default:
        return const SizedBox();
    }
  }
}

// Clase de soporte privada
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