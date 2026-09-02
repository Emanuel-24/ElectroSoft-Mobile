import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_config.dart';
import '../models/sales_model.dart';

class SalesService {
  static const String baseUrl = '${AppConfig.apiBaseUrl}/sales';
  static const String devolutionsBaseUrl = '${AppConfig.apiBaseUrl}/devolutions';
  final _storage = const FlutterSecureStorage();

  Future<List<SaleModel>> obtenerVentas() async {
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

      final List salesList = data['data'] ?? data;
      return salesList.map((e) => SaleModel.fromJson(e)).toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sesión expirada o no autorizada');
    }

    throw Exception('Error al cargar ventas');
  }

  Future<List<SaleDevolutionModel>> obtenerDevolucionesPorVenta(String saleId) async {
    if (saleId.trim().isEmpty) {
      return const [];
    }

    final token = await _storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$devolutionsBaseUrl/sale/$saleId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List devolutionsList = data['data'] ?? data ?? [];
      return devolutionsList
          .map((e) => SaleDevolutionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sesión expirada o no autorizada');
    }

    return const [];
  }
}
