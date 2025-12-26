/// @widget: Customer Controller
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Customer state management controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer_model.dart';
import '../../data/services/data_service.dart';

final customerControllerProvider =
    StateNotifierProvider<CustomerController, CustomerState>((ref) {
  return CustomerController();
});

class CustomerState {
  final List<CustomerModel> customers;
  final bool isLoading;
  final String? error;

  CustomerState({
    this.customers = const [],
    this.isLoading = false,
    this.error,
  });

  CustomerState copyWith({
    List<CustomerModel>? customers,
    bool? isLoading,
    String? error,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CustomerController extends StateNotifier<CustomerState> {
  final DataService _dataService = DataService();

  CustomerController() : super(CustomerState()) {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    state = state.copyWith(isLoading: true);

    try {
      final data = await _dataService.loadCustomers();
      final customers = data.map((c) => CustomerModel.fromJson(c)).toList();

      state = state.copyWith(
        customers: customers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load customers',
        isLoading: false,
      );
    }
  }
}
