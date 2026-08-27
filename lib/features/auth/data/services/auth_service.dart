import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_config.dart';
import '../../domain/entities/auth_response.dart';

class AuthService {
  final String _baseUrl = AppConfig.apiBaseUrl;
  final _storage = const FlutterSecureStorage();

  Future<AuthResponse?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.body);
        
        await _storage.write(key: 'jwt_token', value: authResponse.data.token);
        
        return authResponse;
      }

      throw Exception('Credenciales incorrectas');
    } on http.ClientException {
      throw Exception('No se pudo conectar con el servidor');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}