import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';

class UserService {
  static const String baseUrl = 'http://localhost:4000/api/users';
  final _storage = const FlutterSecureStorage();

  Future<List<Usuario>> obtenerUsuarios() async {
    final token = await _storage.read(key: 'jwt_token');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List usuariosJson = data['data'];
      return usuariosJson.map((e) => Usuario.fromJson(e)).toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sesión expirada o no tienes permisos para ver usuarios');
    }

    throw Exception('Error al cargar la lista de usuarios');
  }
}