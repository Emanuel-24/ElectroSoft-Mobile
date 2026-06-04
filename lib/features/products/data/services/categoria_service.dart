import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/categoria_model.dart';

class CategoriaService {
  static const String baseUrl = 'http://localhost:4000/api/productCategory';

  Future<List<CategoriaModel>> obtenerCategorias() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List categorias = data['data'];

      return categorias.map((e) => CategoriaModel.fromJson(e)).toList();
    }

    throw Exception('Error al cargar categorías');
  }
}