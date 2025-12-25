/// @widget: Order Generator Utility
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Generates unique sales order numbers

class OrderGenerator {
  static String generateOrderNumber() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month.toString().padLeft(2, '0');
    final timestamp = now.millisecondsSinceEpoch.toString().substring(8);
    
    return 'ORD-$year-$month-$timestamp';
  }

  static String generateInvoiceNumber() {
    final now = DateTime.now();
    final year = now.year;
    final timestamp = now.millisecondsSinceEpoch.toString().substring(8);
    
    return 'INV-$year-$timestamp';
  }
}
