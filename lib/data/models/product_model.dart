/// @widget: Product Model
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Product data model

class ProductModel {
  final String id;
  final String name;
  final String sku;
  final String category;
  final String subcategory;
  final String description;
  final double price;
  final double taxRate;
  final List<StockInfo> stock;
  final String unit;
  final String packaging;
  final int minOrderQuantity;
  final int reorderLevel;
  final List<String> images;
  final List<String> relatedProducts;
  final Map<String, dynamic> specifications;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.price,
    required this.taxRate,
    required this.stock,
    required this.unit,
    required this.packaging,
    required this.minOrderQuantity,
    required this.reorderLevel,
    required this.images,
    required this.relatedProducts,
    required this.specifications,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      taxRate: (json['tax_rate'] ?? 0).toDouble(),
      stock: (json['stock'] as List?)
              ?.map((s) => StockInfo.fromJson(s))
              .toList() ??
          [],
      unit: json['unit'] ?? '',
      packaging: json['packaging'] ?? '',
      minOrderQuantity: json['min_order_quantity'] ?? 1,
      reorderLevel: json['reorder_level'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      relatedProducts: List<String>.from(json['related_products'] ?? []),
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
    );
  }

  int get totalStock {
    return stock.fold(0, (sum, s) => sum + s.quantity - s.reserved);
  }

  bool get isLowStock => totalStock <= reorderLevel;
}

class StockInfo {
  final String warehouseId;
  final int quantity;
  final int reserved;

  StockInfo({
    required this.warehouseId,
    required this.quantity,
    required this.reserved,
  });

  factory StockInfo.fromJson(Map<String, dynamic> json) {
    return StockInfo(
      warehouseId: json['warehouse_id'] ?? '',
      quantity: json['quantity'] ?? 0,
      reserved: json['reserved'] ?? 0,
    );
  }

  int get available => quantity - reserved;
}
