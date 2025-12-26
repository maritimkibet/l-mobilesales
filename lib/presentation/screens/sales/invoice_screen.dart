/// @widget: Invoice Screen
/// @created-date: 25-12-2024
/// @leysco-version: 1.0.0
/// @description: Invoice preview and generation screen

import 'package:flutter/material.dart';
import '../../../data/models/order_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/order_generator.dart';
import '../../widgets/common/l_notification_toast.dart';

class InvoiceScreen extends StatelessWidget {
  final OrderModel order;

  const InvoiceScreen({super.key, required this.order});

  void _downloadInvoice(BuildContext context) {
    LNotificationToast.show(
      context,
      'Invoice downloaded successfully',
      type: NotificationType.success,
    );
  }

  void _shareInvoice(BuildContext context) {
    LNotificationToast.show(
      context,
      'Invoice shared',
      type: NotificationType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoiceNumber = OrderGenerator.generateInvoiceNumber();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareInvoice(context),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadInvoice(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'L-MobileSales',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Enterprise Road, Industrial Area'),
                        const Text('Nairobi, Kenya'),
                        const Text('Tel: +254-20-5551234'),
                        const Text('Email: sales@leysco.co.ke'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'INVOICE',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Invoice #: $invoiceNumber'),
                        Text('Order #: ${order.orderId}'),
                        Text('Date: ${LeysFormatters.formatDate(DateTime.now())}'),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 32),
                // Bill To
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bill To:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(order.customerId),
                          Text(order.deliveryAddress.building),
                          Text(order.deliveryAddress.street),
                          Text(
                              '${order.deliveryAddress.city}, ${order.deliveryAddress.region}'),
                          Text(order.deliveryAddress.postalCode),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Order Date: ${order.orderDate}'),
                          Text('Delivery Date: ${order.deliveryDate}'),
                          Text('Payment: ${order.paymentMethod}'),
                          Text('Status: ${order.paymentStatus}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Items Table
                Table(
                  border: TableBorder.all(color: Colors.grey[300]!),
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      children: [
                        _buildTableCell('Item', isHeader: true),
                        _buildTableCell('Qty', isHeader: true),
                        _buildTableCell('Unit Price', isHeader: true),
                        _buildTableCell('Total', isHeader: true),
                      ],
                    ),
                    ...order.items.map((item) => TableRow(
                          children: [
                            _buildTableCell(item.productId),
                            _buildTableCell('${item.quantity}'),
                            _buildTableCell(
                                LeysFormatters.leysSalesFormatter(item.unitPrice)),
                            _buildTableCell(
                                LeysFormatters.leysSalesFormatter(item.total)),
                          ],
                        )),
                  ],
                ),
                const SizedBox(height: 24),
                // Totals
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          _buildTotalRow('Subtotal', order.totalAmount),
                          _buildTotalRow('Tax (${order.items.first.taxRate}%)',
                              order.taxAmount),
                          if (order.discountAmount > 0)
                            _buildTotalRow('Discount', -order.discountAmount,
                                isDiscount: true),
                          const Divider(height: 16),
                          _buildTotalRow('Total Amount', order.netAmount,
                              isTotal: true),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Notes
                if (order.notes.isNotEmpty) ...[
                  Text(
                    'Notes:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(order.notes),
                  const SizedBox(height: 24),
                ],
                // Footer
                const Divider(),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Thank you for your business!',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'For inquiries, contact us at sales@leysco.co.ke',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            LeysFormatters.leysSalesFormatter(amount),
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isDiscount ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}
