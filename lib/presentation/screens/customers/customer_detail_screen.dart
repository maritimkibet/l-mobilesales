/// @widget: Customer Detail Screen
/// @created-date: 25-12-2024
/// @leysco-version: 1.0.0
/// @description: Detailed customer view with contact info and purchase history

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/customer_model.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/common/l_notification_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final CustomerModel customer;

  const CustomerDetailScreen({super.key, required this.customer});

  Future<void> _makeCall(BuildContext context, String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        LNotificationToast.show(
          context,
          'Cannot make call',
          type: NotificationType.error,
        );
      }
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        LNotificationToast.show(
          context,
          'Cannot send email',
          type: NotificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableCredit = customer.creditLimit - customer.currentBalance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              LNotificationToast.show(
                context,
                'Edit customer',
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
            // Header Card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        customer.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      customer.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(customer.category).withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Category ${customer.category}',
                        style: TextStyle(
                          color: _getCategoryColor(customer.category),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer.type,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            // Contact Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Contact Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Contact Person'),
                    subtitle: Text(customer.contactPerson),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone'),
                    subtitle: Text(customer.phone),
                    trailing: IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () => _makeCall(context, customer.phone),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(customer.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.mail),
                      onPressed: () => _sendEmail(context, customer.email),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Address'),
                    subtitle: Text(
                      '${customer.physicalAddress.building}, ${customer.physicalAddress.street}\n${customer.physicalAddress.city}, ${customer.physicalAddress.region}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.map),
                      onPressed: () {
                        Navigator.pushNamed(context, '/customer-map');
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: const Text('Tax ID'),
                    subtitle: Text(customer.taxId),
                  ),
                ],
              ),
            ),
            // Financial Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Financial Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFinancialRow(
                      'Credit Limit',
                      LeysFormatters.leysSalesFormatter(customer.creditLimit),
                    ),
                    const SizedBox(height: 12),
                    _buildFinancialRow(
                      'Current Balance',
                      LeysFormatters.leysSalesFormatter(customer.currentBalance),
                    ),
                    const SizedBox(height: 12),
                    _buildFinancialRow(
                      'Available Credit',
                      LeysFormatters.leysSalesFormatter(availableCredit),
                      color: availableCredit > 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 12),
                    _buildFinancialRow(
                      'Payment Terms',
                      customer.paymentTerms,
                    ),
                  ],
                ),
              ),
            ),
            // Business Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Business Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow('Territory', customer.territory),
                    _buildInfoRow('Sales Person', customer.salesPerson),
                    _buildInfoRow('Order Frequency', customer.orderFrequency),
                    _buildInfoRow('Last Order',
                        customer.lastOrderDate),
                    _buildInfoRow('Customer Since',
                        customer.createdDate),
                  ],
                ),
              ),
            ),
            // Purchase History
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recent Purchase History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPurchaseItem(
                    'ORD-2025-04-001',
                    DateTime(2025, 4, 1),
                    49450.00,
                    'Delivered',
                  ),
                  const Divider(height: 1),
                  _buildPurchaseItem(
                    'ORD-2025-03-15',
                    DateTime(2025, 3, 15),
                    35200.00,
                    'Delivered',
                  ),
                  const Divider(height: 1),
                  _buildPurchaseItem(
                    'ORD-2025-02-28',
                    DateTime(2025, 2, 28),
                    42800.00,
                    'Delivered',
                  ),
                ],
              ),
            ),
            // Notes
            if (customer.notes.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Notes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(customer.notes),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'A+':
        return Colors.purple;
      case 'A':
        return Colors.blue;
      case 'B+':
        return Colors.green;
      case 'B':
        return Colors.orange;
      case 'C+':
        return Colors.amber;
      case 'C':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildFinancialRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
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

  Widget _buildPurchaseItem(
      String orderId, DateTime date, double amount, String status) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.withAlpha(51),
        child: const Icon(Icons.receipt, color: Colors.green),
      ),
      title: Text(orderId),
      subtitle: Text(LeysFormatters.formatDate(date)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            LeysFormatters.leysSalesFormatter(amount),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}
