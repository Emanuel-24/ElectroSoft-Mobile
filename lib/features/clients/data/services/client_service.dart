import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_config.dart';
import '../../domain/entities/client.dart';

class ClientService {
  static const String baseUrl = '${AppConfig.apiBaseUrl}/clients';
  final _storage = const FlutterSecureStorage();

  Future<List<Cliente>> obtenerClientes() async {
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

      final List clientesJson = data['data'];
      return clientesJson.map((e) => Cliente.fromJson(e)).toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sesión expirada o no tienes permisos para ver clientes');
    }

    throw Exception('Error al cargar la lista de clientes');
  }
}
