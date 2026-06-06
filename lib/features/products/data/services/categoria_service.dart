import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/categoria_model.dart';

class CategoriaService {
  static const String baseUrl = 'http://localhost:4000/api/productCategory';
  final _storage = const FlutterSecureStorage();

  Future<List<CategoriaModel>> obtenerCategorias() async {
    final token = await _storage.read(key: 'auth_token');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List categorias = data['data'];
      return categorias.map((e) => CategoriaModel.fromJson(e)).toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sesión expirada o no autorizada');
    }

    throw Exception('Error al cargar categorías');
  }
}