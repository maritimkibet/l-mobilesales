/// @widget: Formatters Utility
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Custom formatting utilities for the application

import 'package:intl/intl.dart';

class LeysFormatters {
  static String leysSalesFormatter(double amount, {String currency = 'KES'}) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '$currency ${formatter.format(amount)} /=';
  }

  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
}
