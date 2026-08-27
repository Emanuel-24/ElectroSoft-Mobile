import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_config.dart';
import '../models/product_model.dart';

class ProductService {
  static const String baseUrl = '${AppConfig.apiBaseUrl}/products';
  final _storage = const FlutterSecureStorage();

  Future<List<ProductModel>> obtenerProductos() async {
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
      final List products = data['data'];
      return products.map((e) => ProductModel.fromJson(e)).toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sesión expirada o no autorizada');
    }

    throw Exception('Error al cargar productos');
  }
}