import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/user_profile.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/profile_input_field.dart';
import '../widgets/profile_dropdown_field.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final ValueChanged<UserProfile>? onSave;

  const EditProfileScreen({super.key, required this.profile, this.onSave});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _documentCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late String _docType;
  File? _pickedImage;

  static const List<String> _docTypes = ['C.C', 'C.E', 'NIT', 'Pasaporte'];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _documentCtrl = TextEditingController(text: p.document);
    _nameCtrl = TextEditingController(text: p.fullName);
    _emailCtrl = TextEditingController(text: p.email);
    _phoneCtrl = TextEditingController(text: p.phone);
    _docType = p.documentType;
  }

  @override
  void dispose() {
    _documentCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = widget.profile.copyWith(
      documentType: _docType,
      document: _documentCtrl.text.trim(),
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );

    widget.onSave?.call(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppTheme.verde,
        content: Text(
          'Perfil actualizado con éxito',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Títulos ---
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Editar ',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  TextSpan(
                    text: 'perfil',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Actualiza tu información personal y foto de perfil.',
              style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
            ),

            const SizedBox(height: 30),

            // --- Avatar ---
            Center(
              child: AvatarPicker(
                avatarUrl: widget.profile.avatarUrl,
                pickedFile: _pickedImage,
                onTap: () {
                  // Aquí conectas tu ImagePicker después
                },
              ),
            ),

            const SizedBox(height: 20),

            // --- Campos del Formulario ---
            ProfileDropdownField(
              label: 'Tipo de documento',
              icon: Icons.badge_outlined,
              value: _docType,
              items: _docTypes,
              onChanged: (v) => setState(() => _docType = v!),
            ),

            const SizedBox(height: 16),

            ProfileInputField(
              label: 'Número de documento',
              icon: Icons.credit_card_outlined,
              controller: _documentCtrl,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            ProfileInputField(
              label: 'Nombre completo',
              icon: Icons.person_outline_rounded,
              controller: _nameCtrl,
            ),

            const SizedBox(height: 16),

            ProfileInputField(
              label: 'Correo electrónico',
              icon: Icons.mail_outline_rounded,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            ProfileInputField(
              label: 'Teléfono',
              icon: Icons.phone_outlined,
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            ProfileInputField(
              label: 'Rol en el sistema',
              icon: Icons.shield_outlined,
              controller: TextEditingController(text: widget.profile.role),
              readOnly: true,
            ),

            const SizedBox(height: 40),

            // --- Botón de Guardar ---
            Center(
              // <--- Este widget es la clave para centrarlo
              child: SizedBox(
                width: 200, // <--- Ancho fijo de 200 como pediste
                height: 54,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, Color(0xFFFFD633)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w800,
                        fontSize:
                            14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
