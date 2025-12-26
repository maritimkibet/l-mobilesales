/// @widget: Dashboard Screen
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Main dashboard with sales summary and quick actions

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/dashboard/l_greeting_header.dart';
import '../../widgets/dashboard/l_sales_summary_card.dart';
import '../../widgets/dashboard/l_quick_actions.dart';
import '../../widgets/dashboard/l_recent_activity.dart';
import '../notifications/notifications_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dashboard updated'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('L-MobileSales'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            LGreetingHeader(
              greeting: _getGreeting(),
              userName: user?.firstName ?? 'User',
            ),
            const SizedBox(height: 20),
            const LSalesSummaryCard(
              totalSales: 245650.00,
              ordersCount: 12,
              itemsSold: 156,
              target: 500000.00,
            ),
            const SizedBox(height: 20),
            const LQuickActions(),
            const SizedBox(height: 20),
            const LRecentActivity(),
          ],
        ),
      ),
    );
  }
}
