import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationServiceAPI _notificationServiceAPI = NotificationServiceAPI();
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final notifs = await _notificationServiceAPI.getRecentNotifications();
      if (mounted) {
        setState(() {
          _notifications = notifs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : _notifications.isEmpty
              ? const Center(child: Text("No hay notificaciones disponibles"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notif = _notifications[index];
                    
                    IconData iconData = Icons.notifications;
                    Color iconColor = Colors.orange;

                    if (notif['type'] == 'SALE') {
                      iconData = Icons.shopping_cart_checkout;
                      iconColor = Colors.green;
                    } else if (notif['type'] == 'USER') {
                      iconData = Icons.person_add_outlined;
                      iconColor = Colors.blue;
                    } else if (notif['type'] == 'PAYMENT') {
                      iconData = Icons.attach_money;
                      iconColor = Colors.amber;
                    }

                    String timeText = 'Ahora';
                    if (notif['createdAt'] != null) {
                      try {
                        final date = DateTime.parse(notif['createdAt']);
                        final diff = DateTime.now().difference(date);
                        if (diff.inMinutes < 60) {
                          timeText = 'Hace ${diff.inMinutes}m';
                        } else if (diff.inHours < 24) {
                          timeText = 'Hace ${diff.inHours}h';
                        } else {
                          timeText = 'Hace ${diff.inDays}d';
                        }
                      } catch (_) {}
                    }

                    return _notificationItem(
                      title: notif['title'] ?? 'Notificación',
                      description: notif['description'] ?? '',
                      time: timeText,
                      icon: iconData,
                      iconColor: iconColor,
                      isUnread: notif['isRead'] == false,
                    );
                  },
                ),
    );
  }

  Widget _notificationItem({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color iconColor,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: isUnread ? Border.all(color: AppTheme.primary.withValues(alpha: 0.01), width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
            if (isUnread)
              const CircleAvatar(radius: 4, backgroundColor: AppTheme.primary),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.3),
            ),
            const SizedBox(height: 8),
            Text(time, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }
}