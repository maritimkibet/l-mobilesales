/// @widget: LCustomerCard
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Customer card widget for customer listing

import 'package:flutter/material.dart';
import '../../../data/models/customer_model.dart';
import '../../../core/utils/formatters.dart';

class LCustomerCard extends StatelessWidget {
  final CustomerModel customer;

  const LCustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(customer.category).withAlpha(51),
          child: Text(
            customer.category,
            style: TextStyle(
              color: _getCategoryColor(customer.category),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${customer.contactPerson} • ${customer.type}'),
            Text(customer.phone),
            Text(
              'Balance: ${LeysFormatters.leysSalesFormatter(customer.currentBalance)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              customer.territory,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/customer-detail',
            arguments: customer,
          );
        },
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
      default:
        return Colors.grey;
    }
  }
}
