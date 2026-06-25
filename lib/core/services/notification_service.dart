import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationServiceAPI {
  final String _baseUrl = 'http://localhost:4000/api/notifications';

  Future<List<dynamic>> getRecentNotifications() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error cargando notificaciones');
      }
    } catch (e) {
      throw Exception('Excepción al cargar notificaciones: $e');
    }
  }
}
