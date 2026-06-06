import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/document_type.dart';

class ProfileService {
  static const String baseUrl = 'http://localhost:4000/api/users';
  final _storage = const FlutterSecureStorage();

  Future<bool> actualizarPerfil({
    required String userId,
    required String fullName,
    required String email,
    required String phone,
    required String documentNumber,
    required String documentAbbreviation,
  }) async {
    final token = await _storage.read(key: 'jwt_token');

    final response = await http.put(
      Uri.parse('$baseUrl/$userId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'documentNumber': documentNumber,
        'documentAbbreviation': documentAbbreviation,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }

    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Error al actualizar el perfil');
  }

  Future<List<DocumentTypeEntity>> obtenerTiposDocumento() async {
    final token = await _storage.read(key: 'jwt_token');
    const String docUrl = 'http://localhost:4000/api/documentTypes';

    final response = await http.get(
      Uri.parse(docUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List listJson = data['data'];
      return listJson.map((e) => DocumentTypeEntity.fromJson(e)).toList();
    }

    throw Exception('Error al cargar tipos de documento');
  }
}