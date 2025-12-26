/// @widget: Home Screen
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Main home screen with bottom navigation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard/dashboard_screen.dart';
import '../sales/sales_screen.dart';
import '../inventory/inventory_screen.dart';
import '../customers/customers_screen.dart';
import '../../widgets/common/l_app_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const SalesScreen(),
    const InventoryScreen(),
    const CustomersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LAppDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Sales',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_outlined),
            selectedIcon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Customers',
          ),
        ],
      ),
    );
  }
}
