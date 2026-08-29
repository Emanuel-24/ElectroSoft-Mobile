import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_config.dart';
import '../models/order_model.dart';

class OrderService {
  static const String baseUrl = '${AppConfig.apiBaseUrl}/orders';
  final _storage = const FlutterSecureStorage();

  Future<List<OrderModel>> obtenerPedidos() async {
    final token = await _storage.read(key: 'jwt_token');

    final response = await http.get(
      Uri.parse('$baseUrl?t=${DateTime.now().millisecondsSinceEpoch}'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List pedidos = data['data'];
      return pedidos.map((e) => OrderModel.fromJson(e)).toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sesión expirada o no autorizada');
    }

    throw Exception('Error al cargar pedidos');
  }
}