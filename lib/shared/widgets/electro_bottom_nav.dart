import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.divider, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    widget.onTabChanged?.call(index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 3,
                        width: isActive ? 32 : 0,
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Icon(
                        isActive ? (item.activeIcon ?? item.icon) : item.icon,
                        size: 24,
                        color: isActive ? AppTheme.primary : AppTheme.textMuted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: AppTheme.navLabel.copyWith(
                          color: isActive
                              ? AppTheme.primary
                              : AppTheme.textMuted,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class ElectroNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;

  const ElectroNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });

  static List<ElectroNavItem> defaults() => const [
    ElectroNavItem(
      label: 'Dashboard',
      icon: Icons.grid_view_rounded,
    ),
    ElectroNavItem(
      label: 'Usuarios',
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
    ),
    ElectroNavItem(
      label: 'Compras',
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_rounded,
    ),
    ElectroNavItem(
      label: 'Productos',
      icon: Icons.sell_outlined,
      activeIcon: Icons.sell_rounded,
    ),
    ElectroNavItem(
      label: 'Perfil',
      icon: Icons.account_circle_outlined,
      activeIcon: Icons.account_circle_rounded,
    ),
  ];
}