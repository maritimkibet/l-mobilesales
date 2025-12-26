/// @widget: LGreetingHeader
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Dynamic greeting header based on time of day

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LGreetingHeader extends StatelessWidget {
  final String greeting;
  final String userName;

  const LGreetingHeader({
    super.key,
    required this.greeting,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMMM d, y').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          dateStr,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
