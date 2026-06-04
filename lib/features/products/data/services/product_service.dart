import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService {
  static const String baseUrl = 'http://localhost:4000/api/products';

  Future<List<ProductModel>> obtenerProductos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List products = data['data'];

      return products.map((e) => ProductModel.fromJson(e)).toList();
    }

    throw Exception('Error al cargar productos');
  }
}