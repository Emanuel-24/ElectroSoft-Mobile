import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ElectroAppBar
///
/// Navbar reutilizable de ElectroSoft. Implementa [PreferredSizeWidget]
/// para usarse directamente como [Scaffold.appBar].
///
/// PARÁMETROS:
///   - [title]       Título de la pantalla actual (ej. "Gestión de roles").
///                   Si es vacío y [showSearch] es false, solo se muestra
///                   la fila del logo (altura reducida automáticamente).
///   - [showSearch]  Muestra u oculta la barra de búsqueda (default: true).
///   - [searchHint]  Placeholder del campo de búsqueda.
///   - [onSearch]    Callback que recibe el texto escrito.
///   - [onAvatarTap] Callback al tocar el avatar del usuario.
///   - [avatarUrl]   URL de la foto del usuario (null = ícono genérico).
///
/// USO BÁSICO:
///   Scaffold(
///     appBar: ElectroAppBar(title: 'Mi pantalla'),
///     body: ...,
///   )
///
/// USO COMPLETO:
///   Scaffold(
///     appBar: ElectroAppBar(
///       title: 'Gestión de roles',
///       searchHint: 'Buscar rol...',
///       onSearch: (value) => setState(() => _query = value),
///       onAvatarTap: () => Navigator.pushNamed(context, '/profile'),
///     ),
///     body: ...,
///   )
/// ─────────────────────────────────────────────────────────────────────────────
class ElectroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;
  final String searchHint;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onAvatarTap;
  final String? avatarUrl;

  const ElectroAppBar({
    super.key,
    required this.title,
    this.showSearch = true,
    this.searchHint = 'Buscar...',
    this.onSearch,
    this.onAvatarTap,
    this.avatarUrl,
  });

  // Solo muestra la fila del logo cuando no hay título ni búsqueda
  bool get _soloLogo => title.isEmpty && !showSearch;

  @override
  Size get preferredSize => Size.fromHeight(_soloLogo ? 72 : 130);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: AppTheme.surface,
      padding: EdgeInsets.only(
        top: topPadding + 8,
        left: 20,
        right: 20,
        bottom: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Fila 1: Logo + Avatar ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Logo(),
              _Avatar(url: avatarUrl, onTap: onAvatarTap),
            ],
          ),

          // ── Fila 2: Título + Búsqueda (solo si hay contenido) ──
          if (!_soloLogo) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (title.isNotEmpty) Text(title, style: AppTheme.pageTitle),
                if (showSearch) ...[
                  if (title.isNotEmpty) const SizedBox(width: 16),
                  Expanded(
                    child: _SearchBar(hint: searchHint, onChanged: onSearch),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Logo ─────────────────────────────────────────────────────────────────────
class _Logo extends StatelessWidget {
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

// ─── Avatar ───────────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String? url;
  final VoidCallback? onTap;

  const _Avatar({this.url, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppTheme.avatarBg,
        backgroundImage: url != null ? NetworkImage(url!) : null,
        child: url == null
            ? const Icon(Icons.person_rounded, color: Colors.white, size: 22)
            : null,
      ),
    );
  }
}

// ─── SearchBar ────────────────────────────────────────────────────────────────
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
          color: AppTheme.primary.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
