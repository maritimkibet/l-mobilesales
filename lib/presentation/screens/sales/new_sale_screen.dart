/// @widget: New Sale Screen
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Create new sales order screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/order_generator.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/common/l_notification_toast.dart';

class NewSaleScreen extends ConsumerStatefulWidget {
  const NewSaleScreen({super.key});

  @override
  ConsumerState<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends ConsumerState<NewSaleScreen> {
  String? _selectedCustomer;
  final List<Map<String, dynamic>> _orderItems = [];
  double _totalAmount = 0.0;

  void _addItem() {
    setState(() {
      _orderItems.add({
        'product': 'SuperFuel Max 20W-50',
        'quantity': 1,
        'price': 4500.00,
      });
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _totalAmount = _orderItems.fold(
      0.0,
      (sum, item) => sum + (item['quantity'] * item['price']),
    );
  }

  void _submitOrder() {
    if (_selectedCustomer == null) {
      LNotificationToast.show(
        context,
        'Please select a customer',
        type: NotificationType.warning,
      );
      return;
    }

    if (_orderItems.isEmpty) {
      LNotificationToast.show(
        context,
        'Please add at least one item',
        type: NotificationType.warning,
      );
      return;
    }

    final orderNumber = OrderGenerator.generateOrderNumber();
    
    LNotificationToast.show(
      context,
      'Order $orderNumber created successfully',
      type: NotificationType.success,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Selection',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Customer',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'CUS-001',
                              child: Text('Quick Auto Services Ltd'),
                            ),
                            DropdownMenuItem(
                              value: 'CUS-002',
                              child: Text('Premium Motors Kenya'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCustomer = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Order Items',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _addItem,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Item'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_orderItems.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('No items added'),
                            ),
                          )
                        else
                          ..._orderItems.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return ListTile(
                              title: Text(item['product']),
                              subtitle: Text(
                                'Qty: ${item['quantity']} x ${LeysFormatters.leysSalesFormatter(item['price'])}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _orderItems.removeAt(index);
                                    _calculateTotal();
                                  });
                                },
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(77),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      LeysFormatters.leysSalesFormatter(_totalAmount),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Create Order'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
