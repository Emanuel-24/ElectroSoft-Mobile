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
  bool _hasChanges = false;

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

  Future<void> _removeNotification(int index) async {
    final notification = _notifications[index];
    final id = notification['_id'] ?? notification['id']?.toString();

    if (id == null || id.isEmpty) {
      setState(() {
        _notifications.removeAt(index);
        _hasChanges = true;
      });
      return;
    }

    try {
      await _notificationServiceAPI.deleteNotification(id);
    } catch (_) {
      // Si el backend no soporta la eliminación o falla, ocultamos localmente igualmente.
    }

    if (mounted) {
      setState(() {
        _notifications.removeAt(index);
        _hasChanges = true;
      });
    }
  }

  Future<void> _markAsRead(int index) async {
    final notification = _notifications[index];
    final id = notification['_id'] ?? notification['id']?.toString();

    if (id == null || id.isEmpty) {
      setState(() {
        notification['isRead'] = true;
        _hasChanges = true;
      });
      return;
    }

    await _notificationServiceAPI.markNotificationRead(id);

    if (mounted) {
      setState(() {
        notification['isRead'] = true;
        _hasChanges = true;
      });
    }
  }

  Future<void> _markAllAsRead() async {
    if (_notifications.every((notification) => notification['isRead'] == true)) return;

    try {
      await _notificationServiceAPI.markAllNotificationsRead();
      if (mounted) {
        setState(() {
          for (final notification in _notifications) {
            notification['isRead'] = true;
          }
          _hasChanges = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  Future<void> _confirmClearAll() async {
    if (_notifications.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Eliminar todas las notificaciones'),
        content: const Text('¿Deseas eliminar todas las notificaciones? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Borrar todas',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _notificationServiceAPI.clearNotifications();

      if (mounted) {
        setState(() {
          _notifications.clear();
          _hasChanges = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
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
          onPressed: () => Navigator.pop(context, _hasChanges),
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          if (_notifications.any((notification) => notification['isRead'] != true))
            IconButton(
              icon: const Icon(Icons.done_all, color: AppTheme.textDark),
              tooltip: 'Marcar todas como leídas',
              onPressed: _markAllAsRead,
            ),
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.textDark),
              tooltip: 'Borrar todas',
              onPressed: _confirmClearAll,
            ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) Navigator.pop(context, _hasChanges);
        },
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.orange))
            : _notifications.isEmpty
                ? const Center(child: Text("No hay notificaciones disponibles"))
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notif = _notifications[index];
                    final bool isUnread = notif['isRead'] != true;

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
                      isUnread: isUnread,
                      onDelete: () => _removeNotification(index),
                      onMarkAsRead: isUnread ? () => _markAsRead(index) : null,
                    );
                  },
                ),
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
    required VoidCallback onDelete,
    VoidCallback? onMarkAsRead,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? AppTheme.primaryLight.withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isUnread ? Border.all(color: AppTheme.primary.withValues(alpha: 0.15), width: 1) : null,
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
            color: iconColor.withValues(alpha: 0.1),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                if (isUnread && onMarkAsRead != null)
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: const Size(80, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: onMarkAsRead,
                    child: const Text(
                      'Marcar leído',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close_rounded, size: 20, color: AppTheme.textMuted),
          tooltip: 'Eliminar',
          onPressed: onDelete,
        ),
      ),
    );
  }
}