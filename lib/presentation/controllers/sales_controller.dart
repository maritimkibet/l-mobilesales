/// @widget: Sales Controller
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Sales orders state management controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';
import '../../data/services/data_service.dart';

final salesControllerProvider =
    StateNotifierProvider<SalesController, SalesState>((ref) {
  return SalesController();
});

class SalesState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? error;

  SalesState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  SalesState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? error,
  }) {
    return SalesState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SalesController extends StateNotifier<SalesState> {
  final DataService _dataService = DataService();

  SalesController() : super(SalesState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true);

    try {
      final data = await _dataService.loadSalesData();
      final orders = data.map((o) => OrderModel.fromJson(o)).toList();

      state = state.copyWith(
        orders: orders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load orders',
        isLoading: false,
      );
    }
  }
}
