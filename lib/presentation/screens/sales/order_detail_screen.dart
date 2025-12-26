/// @widget: Order Detail Screen
/// @created-date: 25-12-2024
/// @leysco-version: 1.0.0
/// @description: Detailed order view with timeline and actions

import 'package:flutter/material.dart';
import '../../../data/models/order_model.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/common/l_notification_toast.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  void _cancelOrder(BuildContext context) {
    if (order.status == 'Delivered' || order.status == 'Cancelled') {
      LNotificationToast.show(
        context,
        'Cannot cancel ${order.status.toLowerCase()} order',
        type: NotificationType.error,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel order ${order.orderId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              LNotificationToast.show(
                context,
                'Order ${order.orderId} cancelled',
                type: NotificationType.success,
              );
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order.orderId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              LNotificationToast.show(
                context,
                'Share order details',
                type: NotificationType.info,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Timeline
            _buildTimeline(context),
            const Divider(height: 32),
            // Order Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Order ID', order.orderId),
                  _buildInfoRow('Customer', order.customerId),
                  _buildInfoRow('Sales Person', order.salesPerson),
                  _buildInfoRow('Order Date',
                      order.orderDate),
                  _buildInfoRow('Delivery Date',
                      order.deliveryDate),
                  _buildInfoRow('Payment Method', order.paymentMethod),
                  _buildInfoRow('Payment Status', order.paymentStatus),
                  const SizedBox(height: 24),
                  Text(
                    'Order Items',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map((item) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor.withAlpha(51),
                            child: Icon(
                              Icons.inventory_2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          title: Text(item.productId),
                          subtitle: Text(
                            'Qty: ${item.quantity} × ${LeysFormatters.leysSalesFormatter(item.unitPrice)}',
                          ),
                          trailing: Text(
                            LeysFormatters.leysSalesFormatter(item.total),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildTotalRow('Subtotal', order.totalAmount),
                          _buildTotalRow('Tax', order.taxAmount),
                          _buildTotalRow('Discount', -order.discountAmount,
                              isDiscount: true),
                          const Divider(height: 24),
                          _buildTotalRow('Total', order.netAmount,
                              isTotal: true),
                        ],
                      ),
                    ),
                  ),
                  if (order.notes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(order.notes),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Delivery Address',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.deliveryAddress.building),
                          Text(order.deliveryAddress.street),
                          Text(
                              '${order.deliveryAddress.city}, ${order.deliveryAddress.region}'),
                          Text(order.deliveryAddress.postalCode),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _cancelOrder(context),
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel Order'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/invoice',
                      arguments: order.orderId);
                },
                icon: const Icon(Icons.receipt),
                label: const Text('View Invoice'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final statuses = ['Pending', 'Processing', 'Shipped', 'Delivered'];
    final currentIndex = statuses.indexOf(order.status);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            children: List.generate(statuses.length, (index) {
              final isCompleted = index <= currentIndex;
              final isCurrent = index == currentIndex;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (index > 0)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: isCompleted
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                            ),
                          ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                          ),
                          child: Icon(
                            isCompleted ? Icons.check : Icons.circle,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        if (index < statuses.length - 1)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: isCompleted && index < currentIndex
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      statuses[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? Colors.black : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            LeysFormatters.leysSalesFormatter(amount),
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isDiscount ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}
