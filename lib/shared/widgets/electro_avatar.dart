import 'package:flutter/material.dart';
import '../../features/profile/domain/avatar_options.dart';

class ElectroAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String avatarLetter;
  final String avatarColor;
  final double radius;
  final double borderWidth;

  const ElectroAvatar({
    super.key,
    this.avatarUrl,
    this.avatarLetter = 'A',
    this.avatarColor = '#273bf1',
    this.radius = 20,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = avatarUrl != null && avatarUrl!.trim().isNotEmpty;
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: avatarColorFromHex(avatarColor),
      backgroundImage: hasImage ? NetworkImage(avatarUrl!.trim()) : null,
      child: hasImage
          ? null
          : Text(
              avatarLetter.trim().isEmpty
                  ? 'A'
                  : avatarLetter.trim().substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: radius * .9,
              ),
            ),
    );

    if (borderWidth == 0) return avatar;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: avatarBorderColorFromHex(avatarColor),
          width: borderWidth,
        ),
      ),
      child: avatar,
    );
  }
}