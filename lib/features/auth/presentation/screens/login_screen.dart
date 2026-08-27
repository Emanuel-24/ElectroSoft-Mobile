import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_config.dart';
import '../../data/services/auth_service.dart';
import '../../../../shared/widgets/main_shell.dart';

// ---------------------------------------------------------------------------
// Design tokens — dark "circuit board" palette.
// The old amber-on-amber background was low-contrast; here amber is reserved
// as a single glowing accent against a deep navy backdrop, so the button
// (and the logo) actually pop instead of blending in.
// ---------------------------------------------------------------------------
class _Palette {
  static const bgTop = Color(0xFFFFFBEE); // butter cream
  static const bgBottom = Color(0xFFFFF1BF); // soft yellow
  static const accent = Color(
    0xFFF2A93C,
  ); // deep gold — used as a *pop* color, not the CTA
  static const cta = Color(
    0xFF2D3142,
  ); // charcoal navy — the button lives here now,
  // so it never blends into the yellow background again
  static const ctaDim = Color(0xFF4B5066);
  static const cardFill = Color(0xF2FFFFFF); // white @ ~95%
  static const cardBorder = Color(0x14000000); // black @ 8%
  static const inputFill = Color(0xFFFFFCF3);
  static const inputBorder = Color(0x1F2D3142);
  static const textPrimary = Color(0xFF2D3142);
  static const textSecondary = Color(0x992D3142); // navy @ 60%
  static const hint = Color(0x662D3142); // navy @ 40%
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // ---------------------------------------------------------------------
  // Business logic — untouched.
  // ---------------------------------------------------------------------
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellene todos los campos.'),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authResponse = await _authService.login(email, password);

      if (authResponse != null && authResponse.success) {
        if (!mounted) return;

        final usuarioLogueado = authResponse.data.user;
        final bool esAdmin = AppConfig.isAdminRole(usuarioLogueado.role);

        if (!esAdmin) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Solo los administradores pueden iniciar sesión en esta app.',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
          await _authService.logout();
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión exitoso. Ingresando...'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        await Future<void>.delayed(const Duration(seconds: 3));
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MainShell(initialIndex: 0, usuario: usuarioLogueado),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      final errorMessage = e.toString().replaceAll('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------
  // UI — redesigned.
  // ---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_Palette.bgTop, _Palette.bgBottom],
              ),
            ),
          ),

          // Ambient glow behind the logo/icon
          Positioned(
            top: -80,
            left: -60,
            child: _GlowBlob(
              color: _Palette.accent.withValues(alpha: 0.18),
              size: 260,
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: _GlowBlob(
              color: _Palette.accent.withValues(alpha: 0.10),
              size: 300,
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 30,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // LOGO ELECTROSOFT
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Electro',
                                      style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                        color: _Palette.textPrimary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Soft',
                                      style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                        color: _Palette.accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 36),

                              // Signature badge — bolt in a glowing ring instead
                              // of a generic account icon
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      _Palette.accent.withValues(alpha: 0.22),
                                      _Palette.accent.withValues(alpha: 0.05),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: _Palette.accent.withValues(
                                      alpha: 0.4,
                                    ),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _Palette.accent.withValues(
                                        alpha: 0.28,
                                      ),
                                      blurRadius: 30,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline,
                                  size: 42,
                                  color: _Palette.cta,
                                ),
                              ),
                              const SizedBox(height: 24),

                              const SizedBox(height: 6),
                              const Text(
                                'Ingrese sus credenciales para continuar',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: _Palette.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 36),

                              // Glass card holding the form
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 18,
                                    sigmaY: 18,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      22,
                                      26,
                                      22,
                                      26,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _Palette.cardFill,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _Palette.cardBorder,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        // CAMPO EMAIL
                                        _buildTextField(
                                          controller: _emailController,
                                          hint: 'Ingrese su email',
                                          icon: Icons.email_outlined,
                                        ),
                                        const SizedBox(height: 16),

                                        // CAMPO DE CONTRASEÑA
                                        _buildTextField(
                                          controller: _passwordController,
                                          hint: 'Ingrese su contraseña',
                                          icon: Icons.lock_outline,
                                          isPassword: true,
                                          obscureText: !_isPasswordVisible,
                                          onSuffixIconPressed: () {
                                            setState(
                                              () => _isPasswordVisible =
                                                  !_isPasswordVisible,
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 28),

                                        // BOTON ACCEDER — ahora es el color más
                                        // oscuro de toda la pantalla, así que
                                        // nunca se pierde contra el fondo claro
                                        SizedBox(
                                          width: double.infinity,
                                          height: 52,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: _Palette.cta
                                                      .withValues(alpha: 0.28),
                                                  blurRadius: 18,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: _isLoading
                                                  ? null
                                                  : _handleLogin,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: _Palette.cta,
                                                disabledBackgroundColor:
                                                    _Palette.ctaDim,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: _isLoading
                                                  ? const SizedBox(
                                                      width: 22,
                                                      height: 22,
                                                      child:
                                                          CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 2.5,
                                                          ),
                                                    )
                                                  : const Text(
                                                      'Acceder',
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixIconPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _Palette.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Palette.inputBorder, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: _Palette.textPrimary),
        cursorColor: _Palette.accent,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _Palette.hint),
          prefixIcon: Icon(icon, color: _Palette.accent),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: _Palette.textSecondary,
                  ),
                  onPressed: onSuffixIconPressed,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 18,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Decorative helpers
// ---------------------------------------------------------------------------
class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}