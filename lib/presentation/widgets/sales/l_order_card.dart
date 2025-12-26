/// @widget: LOrderCard
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Order card widget for sales listing

import 'package:flutter/material.dart';
import '../../../data/models/order_model.dart';
import '../../../core/utils/formatters.dart';

class LOrderCard extends StatelessWidget {
  final OrderModel order;

  const LOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order.status).withAlpha(51),
          child: Icon(
            Icons.shopping_cart,
            color: _getStatusColor(order.status),
          ),
        ),
        title: Text(
          order.orderId,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.customerId}'),
            Text('Items: ${order.items.length}'),
            Text(
              'Date: ${LeysFormatters.formatDate(DateTime.parse(order.orderDate))}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              LeysFormatters.leysSalesFormatter(order.netAmount),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withAlpha(51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.status,
                style: TextStyle(
                  fontSize: 10,
                  color: _getStatusColor(order.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/order-detail',
            arguments: order,
          );
        },
      ),
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
