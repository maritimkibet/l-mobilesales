/// @widget: Inventory Controller
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Inventory state management controller

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../data/services/data_service.dart';

final inventoryControllerProvider =
    StateNotifierProvider<InventoryController, InventoryState>((ref) {
  return InventoryController();
});

class InventoryState {
  final List<ProductModel> products;
  final bool isLoading;
  final String? error;

  InventoryState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  InventoryState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    String? error,
  }) {
    return InventoryState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class InventoryController extends StateNotifier<InventoryState> {
  final DataService _dataService = DataService();

  InventoryController() : super(InventoryState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);

    try {
      final data = await _dataService.loadProducts();
      final products = data.map((p) => ProductModel.fromJson(p)).toList();

      state = state.copyWith(
        products: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load products',
        isLoading: false,
      );
    }
  }
}
