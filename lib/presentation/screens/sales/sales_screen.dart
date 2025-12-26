/// @widget: Sales Screen
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Sales orders listing and management screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/sales_controller.dart';
import '../../widgets/sales/l_order_card.dart';
import 'new_sale_screen.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesState = ref.watch(salesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Orders'),
      ),
      body: salesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : salesState.orders.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: salesState.orders.length,
                  itemBuilder: (context, index) {
                    return LOrderCard(order: salesState.orders[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewSaleScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Sale'),
      ),
    );
  }
}
