/// ─────────────────────────────────────────────────────────────────────────────
/// UserProfile — Modelo de datos del usuario
///
/// Importa donde lo necesites:
///   import 'package:electrosoft/models/user_profile.dart';
/// ─────────────────────────────────────────────────────────────────────────────
class UserProfile {
  final String documentType;
  final String document;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? avatarUrl;

  const UserProfile({
    this.documentType = 'C.C',
    this.document = '',
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.role = '',
    this.avatarUrl,
  });

  UserProfile copyWith({
    String? documentType,
    String? document,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? avatarUrl,
  }) {
    return UserProfile(
      documentType: documentType ?? this.documentType,
      document:     document     ?? this.document,
      fullName:     fullName     ?? this.fullName,
      email:        email        ?? this.email,
      phone:        phone        ?? this.phone,
      role:         role         ?? this.role,
      avatarUrl:    avatarUrl    ?? this.avatarUrl,
    );
  }
}
