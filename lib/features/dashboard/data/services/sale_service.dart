import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/sale_model.dart';

class SaleService {
  static const String baseUrl = 'http://localhost:4000/api/sales';
  final _storage = const FlutterSecureStorage();

  Future<List<SaleModel>> obtenerVentas() async {
    final token = await _storage.read(key: 'auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl?t=${DateTime.now().millisecondsSinceEpoch}'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List ventas = data['data'];
      return ventas.map((e) => SaleModel.fromJson(e)).toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sesión expirada o no autorizada');
    }

    throw Exception('Error al cargar ventas');
  }
}