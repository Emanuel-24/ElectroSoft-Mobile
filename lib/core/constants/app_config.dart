class AppConfig {
  static const String backendBaseUrl = 'https://electro-soft-backend.vercel.app';
  static const String apiBaseUrl = '$backendBaseUrl/api';

  static bool isAdminRole(String? role) {
    final normalized = (role ?? '').trim().toLowerCase();

    if (normalized.isEmpty) return false;

    return normalized == 'admin' ||
        normalized == 'administrator' ||
        normalized == 'superadmin' ||
        normalized.contains('admin');
  }

  static bool isGlobalAdmin(String? email) {
    return (email ?? '').trim().toLowerCase() == 'admin@gmail.com';
  }
}
