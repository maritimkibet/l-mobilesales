/// @widget: LSalesSummaryCard
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Sales summary card with progress indicator

import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';

class LSalesSummaryCard extends StatelessWidget {
  final double totalSales;
  final int ordersCount;
  final int itemsSold;
  final double target;

  const LSalesSummaryCard({
    super.key,
    required this.totalSales,
    required this.ordersCount,
    required this.itemsSold,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSales / target;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Sales',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(
                  Icons.trending_up,
                  color: Colors.green[600],
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              LeysFormatters.leysSalesFormatter(totalSales),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetric(
                    context,
                    'Orders',
                    ordersCount.toString(),
                    Icons.shopping_cart,
                  ),
                ),
                Expanded(
                  child: _buildMetric(
                    context,
                    'Items Sold',
                    itemsSold.toString(),
                    Icons.inventory,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target Progress',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 8),
            Text(
              'Target: ${LeysFormatters.leysSalesFormatter(target)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
