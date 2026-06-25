import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SocketService {
  late IO.Socket socket;
  final AudioPlayer _audioPlayer = AudioPlayer();
  DateTime? _lastSoundPlayed;

  // URL del backend (ajustar si se usa dispositivo físico o emulador)
  final String _serverUrl = 'http://localhost:4000'; 

  // Singleton
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  void initConnection() {
    socket = IO.io(_serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      debugPrint('Conectado a WebSockets Backend');
    });

    socket.onDisconnect((_) {
      debugPrint('Desconectado de WebSockets');
    });
  }

  void onNewNotification(Function(dynamic) callback) {
    socket.on('new_notification', (data) {
      debugPrint('Nueva notificación recibida: $data');
      _playSound();
      callback(data);
    });
  }

  Future<void> _playSound() async {
    final now = DateTime.now();
    // Cooldown de 10 segundos
    if (_lastSoundPlayed != null && now.difference(_lastSoundPlayed!).inSeconds < 10) {
      debugPrint('Sonido omitido por cooldown');
      return;
    }

    try {
      _lastSoundPlayed = now;
      // Asume que hay un archivo notification.mp3 en assets/audio/
      await _audioPlayer.play(AssetSource('audio/notification.mp3'));
    } catch (e) {
      debugPrint('Error al reproducir sonido: $e');
    }
  }

  void disconnect() {
    socket.disconnect();
  }
}
