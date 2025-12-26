/// @widget: Data Service
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Service for loading mock data from JSON files

import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  Future<List<dynamic>> loadUsers() async {
    final String response = await rootBundle.loadString('assets/data/user_data.json');
    return json.decode(response);
  }

  Future<List<dynamic>> loadProducts() async {
    final String response = await rootBundle.loadString('assets/data/products.json');
    return json.decode(response);
  }

  Future<List<dynamic>> loadCustomers() async {
    final String response = await rootBundle.loadString('assets/data/customers.json');
    return json.decode(response);
  }

  Future<List<dynamic>> loadWarehouses() async {
    final String response = await rootBundle.loadString('assets/data/warehouses.json');
    return json.decode(response);
  }

  Future<List<dynamic>> loadSalesData() async {
    final String response = await rootBundle.loadString('assets/data/sales_data.json');
    return json.decode(response);
  }
}
