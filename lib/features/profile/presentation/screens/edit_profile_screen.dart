import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../core/theme/app_theme.dart';
import '../../../users/domain/entities/user_profile.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// EditProfileScreen
///
/// Pantalla de perfil accesible desde el tab "Perfil" del menú inferior.
/// Todo el contenido vive dentro de un SingleChildScrollView para evitar
/// que el avatar quede fijo al hacer scroll.
/// ─────────────────────────────────────────────────────────────────────────────
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Encabezado ───────────────────────────────────────
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Editar ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                ),
                TextSpan(
                  text: 'perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Cambia tu foto de perfil y edita tu información\npersonal.',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted,
              height: 1.4,
            ),
          ),

          // ── Avatar ───────────────────────────────────────────
          const SizedBox(height: 24),
          Center(
            child: _AvatarPicker(
              avatarUrl: widget.profile.avatarUrl,
              pickedFile: _pickedImage,
              onTap: () {
                // TODO: integrar image_picker
                // final img = await ImagePicker().pickImage(source: ImageSource.gallery);
                // if (img != null) setState(() => _pickedImage = File(img.path));
              },
            ),
          ),

          // ── Formulario ───────────────────────────────────────
          const SizedBox(height: 8),
          _DropdownField(
            label: 'Tipo de documento',
            icon: Icons.badge_outlined,
            value: _docType,
            items: _docTypes,
            onChanged: (v) => setState(() => _docType = v!),
          ),
          const SizedBox(height: 14),
          _InputField(
            label: 'Documento',
            icon: Icons.credit_card_outlined,
            controller: _documentCtrl,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          _InputField(
            label: 'Nombre completo',
            icon: Icons.person_outline_rounded,
            controller: _nameCtrl,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 14),
          _InputField(
            label: 'Email',
            icon: Icons.mail_outline_rounded,
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _InputField(
            label: 'Telefono',
            icon: Icons.phone_outlined,
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          _InputField(
            label: 'Rol',
            icon: Icons.shield_outlined,
            controller: TextEditingController(text: widget.profile.role),
            readOnly: true,
          ),
          const SizedBox(height: 28),

          // ── Botón guardar ────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 150,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFFFCC00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: AppTheme.textDark,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Editar Perfil',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Avatar con botón de cambio ───────────────────────────────────────────────
class _AvatarPicker extends StatelessWidget {
  final String? avatarUrl;
  final File? pickedFile;
  final VoidCallback onTap;

  const _AvatarPicker({this.avatarUrl, this.pickedFile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;
    if (pickedFile != null) {
      image = FileImage(pickedFile!);
    } else if (avatarUrl != null) {
      image = NetworkImage(avatarUrl!);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: const Color(0xFFF5D5C0),
          backgroundImage: image,
          child: image == null
              ? const Icon(
                  Icons.person_rounded,
                  size: 48,
                  color: AppTheme.avatarBg,
                )
              : null,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_add_alt_1_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              SizedBox(width: 4),
              Text(
                'Cambiar foto',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ─── Campo de texto ───────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;

  const _InputField({
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.primary),
            const SizedBox(width: 5),
            Text(
              '$label *',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 14, color: AppTheme.textDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 225, 225, 225),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Dropdown ─────────────────────────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.primary),
            const SizedBox(width: 5),
            Text(
              '$label *',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 225, 225, 225),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.textMuted,
              ),
              style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
