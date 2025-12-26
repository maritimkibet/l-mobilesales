/// @widget: Customers Screen
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Customer listing and management screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/customer_controller.dart';
import '../../widgets/customers/l_customer_card.dart';
import 'customer_map_screen.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerMapScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: customerState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : customerState.customers.isEmpty
                    ? const Center(child: Text('No customers found'))
                    : _buildCustomerList(customerState.customers),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList(List customers) {
    final filtered = customers.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.contactPerson.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return LCustomerCard(customer: filtered[index]);
      },
    );
  }
}
