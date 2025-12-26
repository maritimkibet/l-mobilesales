/// @widget: LWarehouseTransferAnimation
/// @created-date: 25-12-2024
/// @leysco-version: 1.0.0
/// @description: Custom animation showing warehouse transfer with dotted path

import 'package:flutter/material.dart';
import 'dart:math' as math;

class LWarehouseTransferAnimation extends StatefulWidget {
  final String fromWarehouse;
  final String toWarehouse;
  final int quantity;
  final String productName;

  const LWarehouseTransferAnimation({
    super.key,
    required this.fromWarehouse,
    required this.toWarehouse,
    required this.quantity,
    required this.productName,
  });

  @override
  State<LWarehouseTransferAnimation> createState() =>
      _LWarehouseTransferAnimationState();
}

class _LWarehouseTransferAnimationState
    extends State<LWarehouseTransferAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Transferring ${widget.quantity} units',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              widget.productName,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _WarehouseTransferPainter(
                      progress: _animation.value,
                      fromWarehouse: widget.fromWarehouse,
                      toWarehouse: widget.toWarehouse,
                      primaryColor: Theme.of(context).primaryColor,
                    ),
                    child: Container(),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWarehouseInfo(
                  context,
                  widget.fromWarehouse,
                  'From',
                  Icons.warehouse,
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
                _buildWarehouseInfo(
                  context,
                  widget.toWarehouse,
                  'To',
                  Icons.warehouse_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarehouseInfo(
      BuildContext context, String warehouse, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          warehouse,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _WarehouseTransferPainter extends CustomPainter {
  final double progress;
  final String fromWarehouse;
  final String toWarehouse;
  final Color primaryColor;

  _WarehouseTransferPainter({
    required this.progress,
    required this.fromWarehouse,
    required this.toWarehouse,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withAlpha(128)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dottedPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw warehouses
    final fromRect = Rect.fromLTWH(20, size.height / 2 - 30, 60, 60);
    final toRect =
        Rect.fromLTWH(size.width - 80, size.height / 2 - 30, 60, 60);

    // Draw warehouse boxes
    paint.style = PaintingStyle.fill;
    paint.color = primaryColor.withAlpha(51);
    canvas.drawRRect(
      RRect.fromRectAndRadius(fromRect, const Radius.circular(8)),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(toRect, const Radius.circular(8)),
      paint,
    );

    // Draw warehouse outlines
    paint.style = PaintingStyle.stroke;
    paint.color = primaryColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(fromRect, const Radius.circular(8)),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(toRect, const Radius.circular(8)),
      paint,
    );

    // Draw dotted path
    final startPoint = Offset(fromRect.right, fromRect.center.dy);
    final endPoint = Offset(toRect.left, toRect.center.dy);
    final controlPoint = Offset(
      (startPoint.dx + endPoint.dx) / 2,
      size.height / 2 - 40,
    );

    _drawDottedCurve(
      canvas,
      dottedPaint,
      startPoint,
      controlPoint,
      endPoint,
    );

    // Draw moving package
    final packagePosition = _getPointOnCurve(
      startPoint,
      controlPoint,
      endPoint,
      progress,
    );

    final packagePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(packagePosition, 8, packagePaint);
    canvas.drawCircle(
      packagePosition,
      12,
      Paint()
        ..color = primaryColor.withAlpha(77)
        ..style = PaintingStyle.fill,
    );

    // Draw package icon
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(
        center: packagePosition,
        width: 8,
        height: 8,
      ),
      iconPaint,
    );
  }

  void _drawDottedCurve(
    Canvas canvas,
    Paint paint,
    Offset start,
    Offset control,
    Offset end,
  ) {
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double distance = 0.0;

    for (double t = 0; t <= 1.0; t += 0.01) {
      final point1 = _getPointOnCurve(start, control, end, t);
      final point2 = _getPointOnCurve(start, control, end, t + 0.01);

      final segmentDistance = (point2 - point1).distance;
      distance += segmentDistance;

      if (distance >= dashWidth + dashSpace) {
        distance = 0;
      }

      if (distance < dashWidth) {
        canvas.drawLine(point1, point2, paint);
      }
    }
  }

  Offset _getPointOnCurve(
      Offset start, Offset control, Offset end, double t) {
    final x = math.pow(1 - t, 2) * start.dx +
        2 * (1 - t) * t * control.dx +
        math.pow(t, 2) * end.dx;
    final y = math.pow(1 - t, 2) * start.dy +
        2 * (1 - t) * t * control.dy +
        math.pow(t, 2) * end.dy;
    return Offset(x.toDouble(), y.toDouble());
  }

  @override
  bool shouldRepaint(_WarehouseTransferPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
