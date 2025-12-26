/// @widget: LNotificationToast
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Custom toast notification widget

import 'package:flutter/material.dart';

enum NotificationType { success, warning, error, info }

class LNotificationToast {
  static void show(
    BuildContext context,
    String message, {
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = _getColor(type);
    final icon = _getIcon(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static Color _getColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.info:
        return Colors.blue;
    }
  }

  static IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.info:
        return Icons.info;
    }
  }
}
