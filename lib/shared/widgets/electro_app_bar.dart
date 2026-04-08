import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ElectroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;
  final bool showBack;
  final String searchHint;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onAvatarTap;
  final String? avatarUrl;

  const ElectroAppBar({
    super.key,
    required this.title,
    this.showSearch = true,
    this.showBack = false,
    this.searchHint = 'Buscar...',
    this.onSearch,
    this.onAvatarTap,
    this.avatarUrl,
  });

  bool get _soloLogo => title.isEmpty && !showSearch;

  @override
  Size get preferredSize => Size.fromHeight(_soloLogo ? 80 : 140);

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
              _Avatar(url: avatarUrl, onTap: onAvatarTap),
            ],
          ),
          if (!_soloLogo) ...[
            const SizedBox(height: 16),
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
