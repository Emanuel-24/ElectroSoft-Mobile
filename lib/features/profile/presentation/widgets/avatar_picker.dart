import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/avatar_options.dart';

class AvatarPicker extends StatelessWidget {
  final String? avatarUrl;
  final String avatarLetter;
  final String avatarColor;
  final ValueChanged<String> onLetterChanged;
  final ValueChanged<String> onColorChanged;

  const AvatarPicker({
    super.key,
    this.avatarUrl,
    this.avatarLetter = 'A',
    this.avatarColor = '#273bf1',
    required this.onLetterChanged,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final image = avatarUrl != null && avatarUrl!.isNotEmpty
        ? NetworkImage(avatarUrl!)
        : null;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: avatarBorderColorFromHex(avatarColor),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: avatarColorFromHex(avatarColor),
            backgroundImage: image,
            child: image == null
                ? Text(
                    avatarLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ),
        TextButton.icon(
          onPressed: () => _showPicker(context),
          icon: const Icon(Icons.expand_more_rounded, size: 18),
          label: const Text('Cambiar avatar'),
          style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Letra', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: avatarLetters
                  .map(
                    (letter) => GestureDetector(
                      onTap: () {
                        onLetterChanged(letter);
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: avatarColorFromHex(avatarColor),
                        child: Text(
                          letter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              children: avatarColors
                  .map(
                    (color) => GestureDetector(
                      onTap: () {
                        onColorChanged(color);
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: avatarColorFromHex(color),
                        child: color == avatarColor
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
