import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/document_type.dart';

class ProfileDropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String selectedAbbreviation;
  final List<DocumentTypeEntity> items;
  final ValueChanged<DocumentTypeEntity?> onChanged;

  const ProfileDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedAbbreviation,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    DocumentTypeEntity? currentValue;
    try {
      currentValue = items.firstWhere(
        (e) => e.abbreviation == selectedAbbreviation,
      );
    } catch (_) {
      currentValue = items.isNotEmpty ? items.first : null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DocumentTypeEntity>(
              value: currentValue,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.textMuted,
              ),
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textDark,
                fontWeight: FontWeight.w500,
              ),
              items: items.map((DocumentTypeEntity type) {
                return DropdownMenuItem<DocumentTypeEntity>(
                  value: type,
                  child: Text('${type.abbreviation} - ${type.name}'),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}