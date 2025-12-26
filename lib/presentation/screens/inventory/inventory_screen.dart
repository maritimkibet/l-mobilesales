/// @widget: Inventory Screen
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Inventory management screen with product listing

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/inventory_controller.dart';
import '../../widgets/inventory/l_product_card.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  bool _isGridView = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
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
                hintText: 'Search products...',
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
            child: inventoryState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : inventoryState.products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : _isGridView
                        ? _buildGridView(inventoryState.products)
                        : _buildListView(inventoryState.products),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List products) {
    final filtered = products.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return LProductCard(product: filtered[index]);
      },
    );
  }

  Widget _buildGridView(List products) {
    final filtered = products.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return LProductCard(product: filtered[index], isGrid: true);
      },
    );
  }
}
