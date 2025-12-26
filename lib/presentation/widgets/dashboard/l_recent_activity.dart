/// @widget: LRecentActivity
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Recent activity feed showing last transactions

import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';

class LRecentActivity extends StatelessWidget {
  const LRecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'orderId': 'ORD-2025-04-001',
        'customer': 'Quick Auto Services',
        'amount': 49450.00,
        'status': 'Delivered',
        'time': '2 hours ago',
      },
      {
        'orderId': 'ORD-2025-04-002',
        'customer': 'Premium Motors Kenya',
        'amount': 168555.00,
        'status': 'Processing',
        'time': '4 hours ago',
      },
      {
        'orderId': 'ORD-2025-03-028',
        'customer': 'City Garage Ltd',
        'amount': 32100.00,
        'status': 'Delivered',
        'time': '1 day ago',
      },
      {
        'orderId': 'ORD-2025-03-027',
        'customer': 'Auto Parts Dealers',
        'amount': 78900.00,
        'status': 'Processing',
        'time': '2 days ago',
      },
      {
        'orderId': 'ORD-2025-03-026',
        'customer': 'Speedway Motors',
        'amount': 54200.00,
        'status': 'Delivered',
        'time': '3 days ago',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getStatusColor(activity['status'] as String)
                      .withAlpha(51),
                  child: Icon(
                    Icons.shopping_bag,
                    color: _getStatusColor(activity['status'] as String),
                  ),
                ),
                title: Text(
                  activity['orderId'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity['customer'] as String),
                    Text(
                      activity['time'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      LeysFormatters.leysSalesFormatter(
                          activity['amount'] as double),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(activity['status'] as String)
                            .withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        activity['status'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: _getStatusColor(activity['status'] as String),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'processing':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
