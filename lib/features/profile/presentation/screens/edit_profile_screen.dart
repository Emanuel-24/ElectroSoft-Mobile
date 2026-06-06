import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../../core/theme/app_theme.dart';
import '../../../users/domain/entities/user.dart';
import '../../domain/entities/document_type.dart';
import '../../data/services/profile_service.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/profile_input_field.dart';
import '../widgets/profile_dropdown_field.dart';

class EditProfileScreen extends StatefulWidget {
  final Usuario profile;
  final VoidCallback? onProfileUpdated;

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
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _documentCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  String _selectedDocAbbreviation = '';
  List<DocumentTypeEntity> _documentTypes = [];
  bool _isLoadingTypes = true;
  bool _isSaving = false;

  List<int>? _pickedImageBytes;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _documentCtrl = TextEditingController(text: p.documentNumber);
    _nameCtrl = TextEditingController(text: p.fullName);
    _emailCtrl = TextEditingController(text: p.email);
    _phoneCtrl = TextEditingController(text: p.phone);
    _selectedDocAbbreviation = p.documentAbbreviation;

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

  Future<void> _seleccionarImagen() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppTheme.primary,
              ),
              title: const Text('Elegir de la galería'),
              onTap: () => _obtenerImagen(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: AppTheme.primary,
              ),
              title: const Text('Tomar foto con la cámara'),
              onTap: () => _obtenerImagen(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _obtenerImagen(ImageSource source) async {
    Navigator.pop(context);
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _pickedImageBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint('Error seleccionando imagen: $e');
    }
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
        documentAbbreviation: _selectedDocAbbreviation,
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
        widget.onProfileUpdated?.call();
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

                    Center(
                      child: AvatarPicker(
                        avatarUrl: '',
                        pickedBytes: _pickedImageBytes != null
                            ? Uint8List.fromList(_pickedImageBytes!)
                            : null,
                        onTap: _seleccionarImagen,
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
                      validator: (v) =>
                          v!.isEmpty ? 'El documento es requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    ProfileInputField(
                      label: 'Nombre completo',
                      icon: Icons.person_outline_rounded,
                      controller: _nameCtrl,
                      validator: (v) =>
                          v!.isEmpty ? 'El nombre es requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    ProfileInputField(
                      label: 'Correo electrónico',
                      icon: Icons.mail_outline_rounded,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v!.isEmpty) return 'El correo es requerido';
                        if (!v.contains('@')) return 'Ingresa un correo válido';
                        return null;
                      },
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