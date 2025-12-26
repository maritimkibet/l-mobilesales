/// @widget: Notifications Screen
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Notification center showing all notifications

import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'New Order Received',
        'message': 'Order ORD-2025-04-003 has been placed',
        'time': '10 minutes ago',
        'type': 'success',
        'read': false,
      },
      {
        'title': 'Low Stock Alert',
        'message': 'SuperFuel Max 20W-50 is running low',
        'time': '1 hour ago',
        'type': 'warning',
        'read': false,
      },
      {
        'title': 'Payment Received',
        'message': 'Payment of KES 49,450.00 /= received from Quick Auto Services',
        'time': '3 hours ago',
        'type': 'success',
        'read': false,
      },
      {
        'title': 'Order Delivered',
        'message': 'Order ORD-2025-04-001 has been delivered',
        'time': '5 hours ago',
        'type': 'info',
        'read': true,
      },
      {
        'title': 'New Customer Added',
        'message': 'Speedway Motors has been added to your customer list',
        'time': '1 day ago',
        'type': 'info',
        'read': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final isRead = notification['read'] as bool;
          
          return Container(
            color: isRead ? null : Colors.blue.withAlpha(13),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getTypeColor(notification['type'] as String)
                    .withAlpha(51),
                child: Icon(
                  _getTypeIcon(notification['type'] as String),
                  color: _getTypeColor(notification['type'] as String),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      notification['title'] as String,
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notification['message'] as String),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Mark as read and show details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opened: ${notification['title']}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'info':
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'info':
      default:
        return Icons.info;
    }
  }
}
