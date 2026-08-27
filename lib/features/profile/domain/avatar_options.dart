import 'package:flutter/material.dart';

final avatarLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
const avatarColors = [
  '#273bf1',
  '#f02d2d',
  '#14b8a6',
  '#1bd43a',
  '#e98c13',
  '#facc15',
  '#ec4899',
  '#a523e0',
];

Color avatarColorFromHex(String value) {
  final hex = value.replaceFirst('#', '');
  final normalized = hex.length == 6 ? 'FF$hex' : hex;
  return Color(int.tryParse(normalized, radix: 16) ?? 0xFF273BF1);
}

Color avatarBorderColorFromHex(String value) {
  final color = avatarColorFromHex(value);
  return Color.fromARGB(
    255,
    ((color.r * 255).round() - 45).clamp(0, 255),
    ((color.g * 255).round() - 45).clamp(0, 255),
    ((color.b * 255).round() - 45).clamp(0, 255),
  );
}
