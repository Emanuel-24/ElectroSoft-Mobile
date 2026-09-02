import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../users/domain/entities/user.dart';
import '../../domain/entities/document_type.dart';
import '../../data/services/profile_service.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/profile_input_field.dart';
import '../widgets/profile_dropdown_field.dart';

class EditProfileScreen extends StatefulWidget {
  final Usuario profile;
  final void Function(String avatarLetter, String avatarColor)?
  onProfileUpdated;

  const EditProfileScreen({
    super.key,
    required this.profile,
    this.onProfileUpdated,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _documentCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  String _selectedDocAbbreviation = '';
  List<DocumentTypeEntity> _documentTypes = [];
  bool _isLoadingTypes = true;
  bool _isSaving = false;
  late String _avatarLetter;
  late String _avatarColor;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _documentCtrl = TextEditingController(text: p.documentNumber);
    _nameCtrl = TextEditingController(text: p.fullName);
    _emailCtrl = TextEditingController(text: p.email);
    _phoneCtrl = TextEditingController(text: p.phone);
    _selectedDocAbbreviation = p.documentAbbreviation;
    _avatarLetter = p.avatarLetter;
    _avatarColor = p.avatarColor;

    _cargarPerfilActual();
    _cargarTiposDocumento();
  }

  @override
  void dispose() {
    _documentCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarTiposDocumento() async {
    try {
      final types = await _profileService.obtenerTiposDocumento();
      setState(() {
        _documentTypes = types;
        _isLoadingTypes = false;
      });
    } catch (e) {
      setState(() => _isLoadingTypes = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar tipos de documento: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _cargarPerfilActual() async {
    try {
      final profile = await _profileService.obtenerPerfilActual(
        widget.profile.id,
      );
      if (!mounted) return;
      setState(() {
        _documentCtrl.text = profile.documentNumber;
        _nameCtrl.text = profile.fullName;
        _emailCtrl.text = profile.email;
        _phoneCtrl.text = profile.phone;
        _selectedDocAbbreviation = profile.documentAbbreviation;
        _avatarLetter = profile.avatarLetter;
        _avatarColor = profile.avatarColor;
      });
    } catch (e) {
      debugPrint('Error cargando perfil actualizado: $e');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final success = await _profileService.actualizarPerfil(
        userId: widget.profile.id,
        fullName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        documentNumber: _documentCtrl.text.trim(),
        documentType: _documentTypes
            .firstWhere(
              (type) => type.abbreviation == _selectedDocAbbreviation,
              orElse: () => DocumentTypeEntity(
                id: widget.profile.documentTypeId,
                name: '',
                abbreviation: _selectedDocAbbreviation,
              ),
            )
            .id,
        avatarLetter: _avatarLetter,
        avatarColor: _avatarColor,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppTheme.verde,
            content: Text(
              'Perfil actualizado con éxito',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        widget.onProfileUpdated?.call(_avatarLetter, _avatarColor);
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoadingTypes
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: RichText(
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Actualiza tu información personal y foto de perfil.',
                      style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 30),

                    Center(
                      child: AvatarPicker(
                        avatarUrl: widget.profile.avatar,
                        avatarLetter: _avatarLetter,
                        avatarColor: _avatarColor,
                        onLetterChanged: (letter) =>
                            setState(() => _avatarLetter = letter),
                        onColorChanged: (color) =>
                            setState(() => _avatarColor = color),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ProfileDropdownField(
                      label: 'Tipo de documento',
                      icon: Icons.badge_outlined,
                      selectedAbbreviation: _selectedDocAbbreviation,
                      items: _documentTypes,
                      onChanged: (type) {
                        if (type != null) {
                          setState(
                            () => _selectedDocAbbreviation = type.abbreviation,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    ProfileInputField(
                      label: 'Número de documento',
                      icon: Icons.credit_card_outlined,
                      controller: _documentCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) return 'El documento es requerido';
                        if (!RegExp(r'^\d{8,12}$').hasMatch(value)) {
                          return 'Debe tener entre 8 y 12 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    ProfileInputField(
                      label: 'Nombre completo',
                      icon: Icons.person_outline_rounded,
                      controller: _nameCtrl,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]'),
                        ),
                        LengthLimitingTextInputFormatter(40),
                      ],
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) return 'El nombre es requerido';
                        if (value.length < 3) return 'Mínimo 3 caracteres';
                        if (value.length > 40) return 'Máximo 40 caracteres';
                        if (!RegExp(
                          r'^[\p{L}\s]+$',
                          unicode: true,
                        ).hasMatch(value)) {
                          return 'Solo se permiten letras';
                        }
                        if (RegExp(r'\s{2,}').hasMatch(value)) {
                          return 'No se permiten espacios dobles';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    ProfileInputField(
                      label: 'Correo electrónico',
                      icon: Icons.mail_outline_rounded,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) return 'El correo es requerido';
                        if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ).hasMatch(value)) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    ProfileInputField(
                      label: 'Teléfono',
                      icon: Icons.phone_outlined,
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(14),
                      ],
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) return 'El teléfono es requerido';
                        if (!RegExp(r'^\d{8,14}$').hasMatch(value)) {
                          return 'Debe tener entre 8 y 14 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    ProfileInputField(
                      label: 'Rol en el sistema',
                      icon: Icons.shield_outlined,
                      controller: TextEditingController(
                        text: widget.profile.roleName.toUpperCase(),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 40),

                    Center(
                      child: SizedBox(
                        width: 200,
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
                            onPressed: _isSaving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: AppTheme.textDark,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Guardar',
                                    style: TextStyle(
                                      color: AppTheme.textDark,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
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
            ),
    );
  }
}
