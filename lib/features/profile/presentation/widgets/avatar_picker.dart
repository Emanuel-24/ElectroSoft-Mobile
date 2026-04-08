import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AvatarPicker extends StatelessWidget {
  final String? avatarUrl;
  final File? pickedFile;
  final VoidCallback onTap;

  const AvatarPicker({
    super.key,
    this.avatarUrl,
    this.pickedFile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (pickedFile != null) {
      image = FileImage(pickedFile!);
    } else if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      image = NetworkImage(avatarUrl!);
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary, width: 2),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFF0F0F0),
            backgroundImage: image,
            child: image == null
                ? const Icon(Icons.person_rounded, size: 50, color: Colors.grey)
                : null,
          ),
        ),
        TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.camera_alt_outlined, size: 18),
          label: const Text('Cambiar foto'),
          style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
        ),
      ],
    );
  }
}
