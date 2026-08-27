import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/app_config.dart';

class NotificationServiceAPI {
  static final NotificationServiceAPI _instance = NotificationServiceAPI._internal();
  factory NotificationServiceAPI() => _instance;
  NotificationServiceAPI._internal();

  final String _baseUrl = '${AppConfig.apiBaseUrl}/notifications';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _pollingTimer;
  bool _requestInProgress = false;
  String? _cursorCreatedAt;
  String? _cursorId;
  DateTime? _lastSoundPlayed;
  static const String _cursorCreatedAtKey = 'notifications_cursor_created_at';
  static const String _cursorIdKey = 'notifications_cursor_id';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> startPolling(Future<void> Function(List<dynamic>, bool) onNotifications) async {
    stopPolling();
    await _loadCursor();
    await _poll(onNotifications, playSound: false, initial: _cursorCreatedAt == null);
    _pollingTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      _poll(onNotifications, playSound: true);
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _poll(
    Future<void> Function(List<dynamic>, bool) onNotifications, {
    required bool playSound,
    bool initial = false,
  }) async {
    if (_requestInProgress) return;
    _requestInProgress = true;
    try {
      final notifications = await _fetchNotifications(incremental: !initial);
      if (notifications.isNotEmpty) {
        await onNotifications(notifications, initial);
        if (playSound) await _playBatchSound();
      }
    } catch (e) {
      debugPrint('Error consultando notificaciones: $e');
    } finally {
      _requestInProgress = false;
    }
  }

  Future<List<dynamic>> _fetchNotifications({required bool incremental}) async {
    final query = <String, String>{'limit': '100'};
    if (incremental && _cursorCreatedAt != null) {
      query['afterCreatedAt'] = _cursorCreatedAt!;
      if (_cursorId != null) query['afterId'] = _cursorId!;
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: query);
    final response = await http.get(uri, headers: await _headers());
    if (response.statusCode != 200) throw Exception('Error cargando notificaciones (${response.statusCode})');

    final decoded = jsonDecode(response.body);
    final notifications = decoded is List ? List<dynamic>.from(decoded) : <dynamic>[];
    _updateCursor(notifications, incremental: incremental);
    return notifications;
  }

  void _updateCursor(List<dynamic> notifications, {required bool incremental}) {
    if (notifications.isEmpty) return;
    final notification = notifications[incremental ? notifications.length - 1 : 0];
    if (notification is Map<String, dynamic> && notification['createdAt'] != null) {
      _cursorCreatedAt = notification['createdAt'].toString();
      _cursorId = notification['_id']?.toString() ?? notification['id']?.toString();
      _saveCursor();
    }
  }

  Future<void> _loadCursor() async {
    _cursorCreatedAt = await _storage.read(key: _cursorCreatedAtKey);
    _cursorId = await _storage.read(key: _cursorIdKey);
  }

  Future<void> _saveCursor() async {
    if (_cursorCreatedAt == null) return;
    await _storage.write(key: _cursorCreatedAtKey, value: _cursorCreatedAt);
    if (_cursorId != null) await _storage.write(key: _cursorIdKey, value: _cursorId);
  }

  Future<void> _playBatchSound() async {
    final now = DateTime.now();
    if (_lastSoundPlayed != null && now.difference(_lastSoundPlayed!).inSeconds < 10) return;
    try {
      _lastSoundPlayed = now;
      await _audioPlayer.play(AssetSource('audio/notification.mp3'));
    } catch (e) {
      debugPrint('Error al reproducir sonido: $e');
    }
  }

  Future<List<dynamic>> getRecentNotifications() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=20'), headers: await _headers());

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded is List ? List<dynamic>.from(decoded) : <dynamic>[];
      } else {
        throw Exception('Error cargando notificaciones');
      }
    } catch (e) {
      throw Exception('Excepción al cargar notificaciones: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$notificationId'), headers: await _headers());
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error eliminando notificación');
      }
    } catch (e) {
      throw Exception('Excepción al eliminar notificación: $e');
    }
  }

  Future<void> clearNotifications() async {
    try {
      final response = await http.delete(Uri.parse(_baseUrl), headers: await _headers());
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error borrando notificaciones');
      }
    } catch (e) {
      throw Exception('Excepción al borrar notificaciones: $e');
    }
  }

  Future<void> markNotificationRead(String notificationId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$notificationId/read'),
      headers: await _headers(),
    );
    if (response.statusCode != 200) throw Exception('Error marcando notificación como leída');
  }

  Future<void> markAllNotificationsRead() async {
    final response = await http.put(Uri.parse('$_baseUrl/mark-read'), headers: await _headers());
    if (response.statusCode != 200) throw Exception('Error marcando notificaciones como leídas');
  }

  Future<void> dispose() async {
    stopPolling();
    await _audioPlayer.dispose();
  }
}
