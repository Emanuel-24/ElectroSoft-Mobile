import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/profile/domain/avatar_options.dart';

class ElectroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;
  final bool showBack;
  final String searchHint;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onAvatarTap;
  final String? avatarUrl;
  final String avatarLetter;
  final String avatarColor;

  const ElectroAppBar({
    super.key,
    required this.title,
    this.showSearch = true,
    this.showBack = false,
    this.searchHint = 'Buscar...',
    this.onSearch,
    this.onAvatarTap,
    this.avatarUrl,
    this.avatarLetter = 'A',
    this.avatarColor = '#273bf1',
  });

  bool get _soloLogo => title.isEmpty && !showSearch;

  @override
  Size get preferredSize => Size.fromHeight(_soloLogo ? 80 : 180);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: AppTheme.surface,
      padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _Logo(),
              _Avatar(
                url: avatarUrl,
                letter: avatarLetter,
                color: avatarColor,
                onAvatarTap: onAvatarTap,
              ),
            ],
          ),
          if (!_soloLogo) ...[
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (showBack) ...[
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                    ],

                    if (title.isNotEmpty)
                      Expanded(child: Text(title, style: AppTheme.pageTitle)),
                  ],
                ),

                if (showSearch) ...[
                  const SizedBox(height: 12),

                  _SearchBar(hint: searchHint, onChanged: onSearch),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppTheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: 'Electro', style: AppTheme.logoElectro),
              TextSpan(text: 'Soft', style: AppTheme.logoSoft),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? url;
  final String letter;
  final String color;
  final VoidCallback? onAvatarTap;

  const _Avatar({
    this.url,
    required this.letter,
    required this.color,
    this.onAvatarTap,
  });

  void _confirmarCerrarSesion(BuildContext context) {
    final AuthService authService = AuthService();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          '¿Cerrar sesión?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          '¿Estás seguro de que deseas salir de ElectroSoft?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await authService.logout();

              if (!context.mounted) return;

              Navigator.pop(dialogContext);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Salir',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = url != null && url!.trim().isNotEmpty;

    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      onSelected: (value) {
        if (value == 'logout') {
          _confirmarCerrarSesion(context);
        } else if (value == 'profile') {
          onAvatarTap?.call();
        }
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: avatarColorFromHex(color),
        backgroundImage: hasImage ? NetworkImage(url!.trim()) : null,
        child: !hasImage
            ? Text(
                letter.trim().isEmpty
                    ? 'A'
                    : letter.trim().substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            : null,
      ),
      itemBuilder: (context) => [
        if (onAvatarTap != null)
          const PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_outlined, color: AppTheme.primary, size: 20),
                SizedBox(width: 12),
                Text('Editar perfil'),
              ],
            ),
          ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 12),
              Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const _SearchBar({required this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppTheme.primary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          isDense: true,
        ),
      ),
    );
  }
}
