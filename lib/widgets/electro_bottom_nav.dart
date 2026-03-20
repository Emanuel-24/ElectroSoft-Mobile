import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ElectroBottomNav
///
/// Barra de navegación inferior reutilizable de ElectroSoft.
/// Maneja su propio estado interno o puede recibir índice externo.
///
/// PARÁMETROS:
///   - [items]        Lista de [ElectroNavItem] que define cada tab.
///   - [initialIndex] Tab activo al iniciar (default: 0).
///   - [onTabChanged] Callback cuando el usuario cambia de tab.
///                    Recibe el índice seleccionado.
///
/// ITEMS PREDEFINIDOS: usa [ElectroNavItem.defaults()] para los 5 tabs
/// estándar de ElectroSoft (Dashboard, Usuarios, Roles, Productos, Más).
///
/// USO CON ITEMS ESTÁNDAR:
///   ElectroBottomNav(
///     items: ElectroNavItem.defaults(),
///     initialIndex: 2,                        // Roles activo
///     onTabChanged: (index) => setState(() => _page = index),
///   )
///
/// USO CON ITEMS PERSONALIZADOS:
///   ElectroBottomNav(
///     items: [
///       ElectroNavItem(label: 'Inicio',    icon: Icons.home_outlined,     activeIcon: Icons.home_rounded),
///       ElectroNavItem(label: 'Perfil',    icon: Icons.person_outline,    activeIcon: Icons.person_rounded),
///       ElectroNavItem(label: 'Ajustes',   icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded),
///     ],
///     onTabChanged: (index) { /* tu lógica */ },
///   )
/// ─────────────────────────────────────────────────────────────────────────────
class ElectroBottomNav extends StatefulWidget {
  final List<ElectroNavItem> items;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;

  const ElectroBottomNav({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.onTabChanged,
  });

  @override
  State<ElectroBottomNav> createState() => _ElectroBottomNavState();
}

class _ElectroBottomNavState extends State<ElectroBottomNav> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.divider, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              final isActive = index == _selectedIndex;
              return Expanded(
                child: _NavTab(
                  item: item,
                  isActive: isActive,
                  onTap: () => _onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Un tab individual ────────────────────────────────────────────────────────
class _NavTab extends StatelessWidget {
  final ElectroNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTab({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador activo en la parte superior
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            height: 3,
            width: isActive ? 32 : 0,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Ícono
          Icon(
            isActive ? (item.activeIcon ?? item.icon) : item.icon,
            size: 24,
            color: isActive ? AppTheme.primary : AppTheme.textMuted,
          ),

          const SizedBox(height: 3),

          // Etiqueta
          Text(
            item.label,
            style: AppTheme.navLabel.copyWith(
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// ElectroNavItem
///
/// Modelo de datos para cada tab de la barra de navegación.
///
/// [label]      Texto visible debajo del ícono.
/// [icon]       Ícono cuando el tab NO está activo.
/// [activeIcon] Ícono cuando el tab SÍ está activo (opcional).
///              Si es null, se usa [icon] para ambos estados.
/// ─────────────────────────────────────────────────────────────────────────────
class ElectroNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;

  const ElectroNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });

  /// Los 5 tabs estándar de ElectroSoft.
  /// Úsalos directamente o modifícalos según el proyecto.
  static List<ElectroNavItem> defaults() => const [
        ElectroNavItem(
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard_rounded,
        ),
        ElectroNavItem(
          label: 'Usuarios',
          icon: Icons.person_outline_rounded,
          activeIcon: Icons.person_rounded,
        ),
        ElectroNavItem(
          label: 'Roles',
          icon: Icons.shield_outlined,
          activeIcon: Icons.shield_rounded,
        ),
        ElectroNavItem(
          label: 'Productos',
          icon: Icons.inventory_2_outlined,
          activeIcon: Icons.inventory_2_rounded,
        ),
        ElectroNavItem(
          label: 'Más',
          icon: Icons.more_horiz_rounded,
        ),
      ];
}
