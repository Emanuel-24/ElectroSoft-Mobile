import 'package:electrosoft/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

// Importaciones de tus pantallas (ajusta las rutas si cambian)
import '../../features/products/presentation/screens/cat_products_screen.dart';
import '../../features/roles/presentation/screens/roles_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../../features/profile/domain/entities/user_profile.dart';
import '../widgets/widgets.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  String _searchQuery = '';

  // Datos del perfil (Esto luego debería venir de un Provider o Backend)
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
    _PageConfig(title: '', showSearch: false,),
    _PageConfig(title: 'Usuarios', searchHint: 'Buscar usuario...'),
    _PageConfig(title: 'Roles', searchHint: 'Buscar rol...'),
    _PageConfig(title: 'Categorias de productos', showSearch: false),
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
        avatarUrl: _userProfile.avatarUrl,
        onAvatarTap: () {
          // Opcional: Ir a la pestaña de perfil al tocar el avatar
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
        // Asegúrate de que UsuariosScreen reciba un parámetro opcional 'searchQuery'
        return UsuariosScreen(searchQuery: _searchQuery);
      case 2:
        return RolesScreen(searchQuery: _searchQuery);
      case 3:
        return CatProductosScreen(searchQuery: _searchQuery);
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

// Clase de soporte privada para organizar las pestañas
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
