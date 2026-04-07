import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'shared/widgets/main_shell.dart'; // <--- Lo moveremos aquí

void main() => runApp(const ElectroSoftApp());

class ElectroSoftApp extends StatelessWidget {
  const ElectroSoftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElectroSoft',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primary),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const MainShell(),
      },
    );
  }
}