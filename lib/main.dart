import 'package:flutter/material.dart';
import 'widgets/widgets.dart';
import 'theme/app_theme.dart';
import 'models/user_profile.dart';
import 'screens/roles_screen.dart';
import 'screens/edit_profile_screen.dart';

void main() {
  runApp(const ElectroSoftApp());
}

class ElectroSoftApp extends StatelessWidget {
  const ElectroSoftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElectroSoft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primary),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  String _searchQuery = '';

  // Perfil del usuario — reemplazar con tu fuente de datos real
  UserProfile _userProfile = const UserProfile(
    fullName: 'Andres Camilo Santa',
    email: 'Andrescamilo@gmail.com',
    phone: '3003478277',
    document: '1232598525',
    documentType: 'C.C',
    role: 'Admin',
  );

  static const List<_PageConfig> _pages = [
    _PageConfig(title: 'Dashboard'),
    _PageConfig(title: 'Usuarios'),
    _PageConfig(title: 'Gestión de roles', searchHint: 'Buscar rol...'),
    _PageConfig(title: 'Productos', searchHint: 'Buscar producto...'),
    _PageConfig(title: '', showSearch: false),
  ];

  String get _currentTitle => _pages[_currentIndex].title;
  String get _currentHint => _pages[_currentIndex].searchHint;
  bool get _showSearch => _pages[_currentIndex].showSearch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElectroAppBar(
        title: _currentTitle,
        showSearch: _showSearch,
        searchHint: _currentHint,
        onSearch: (value) => setState(() => _searchQuery = value),
        onAvatarTap:
            () {}, // avatar sin acción — el perfil está en el tab Perfil
        avatarUrl: _userProfile.avatarUrl,
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

  // ── ✏️  ZONA DE TRABAJO DEL EQUIPO ────────────────────────────────────────
  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const Center(child: Text('Dashboard')); // → DashboardScreen
      case 1:
        return const Center(child: Text('Usuarios')); // → UsuariosScreen
      case 2:
        return const RolesScreen(); // ✅ ya conectado
      case 3:
        return const Center(child: Text('Productos')); // → ProductosScreen
      case 4:
        return EditProfileScreen(
          // ✅ tab Perfil
          profile: _userProfile,
          onSave: (updated) => setState(() => _userProfile = updated),
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
