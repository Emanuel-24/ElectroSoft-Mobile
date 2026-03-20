import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand Colors ──────────────────────────────────────────────
  static const Color primary = Color(0xFFFFCC00);       // Yellow accent
  static const Color primaryLight = Color(0xFFFFF8D6);  // Pale yellow (logo bg)
  static const Color textDark = Color(0xFF1A1A1A);      // Near-black text
  static const Color textMuted = Color(0xFF9E9E9E);     // Gray labels / hints
  static const Color surface = Colors.white;
  static const Color divider = Color(0xFFF0F0F0);
  static const Color avatarBg = Color(0xFFE07B39);      // Orange avatar

  // ── Text Styles ───────────────────────────────────────────────
  static const TextStyle logoElectro = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w800,
    fontSize: 18,
    color: textDark,
    letterSpacing: -0.3,
  );

  static const TextStyle logoSoft = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w800,
    fontSize: 18,
    color: primary,
    letterSpacing: -0.3,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w800,
    fontSize: 22,
    color: textDark,
  );

  static const TextStyle navLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}
