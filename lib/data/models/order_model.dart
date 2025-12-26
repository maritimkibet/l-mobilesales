/// @widget: Order Model
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Sales order data model

class OrderModel {
  final String orderId;
  final String customerId;
  final String orderDate;
  final String deliveryDate;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String salesPerson;
  final double totalAmount;
  final double taxAmount;
  final double discountAmount;
  final double netAmount;
  final List<OrderItem> items;
  final String notes;
  final Address deliveryAddress;

  OrderModel({
    required this.orderId,
    required this.customerId,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.salesPerson,
    required this.totalAmount,
    required this.taxAmount,
    required this.discountAmount,
    required this.netAmount,
    required this.items,
    required this.notes,
    required this.deliveryAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      orderDate: json['order_date'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      salesPerson: json['sales_person'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      netAmount: (json['net_amount'] ?? 0).toDouble(),
      items: (json['items'] as List?)
              ?.map((i) => OrderItem.fromJson(i))
              .toList() ??
          [],
      notes: json['notes'] ?? '',
      deliveryAddress: Address.fromJson(json['delivery_address'] ?? {}),
    );
  }
}

class Address {
  final String street;
  final String building;
  final String city;
  final String region;
  final String postalCode;

  Address({
    required this.street,
    required this.building,
    required this.city,
    required this.region,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      building: json['building'] ?? '',
      city: json['city'] ?? '',
      region: json['region'] ?? '',
      postalCode: json['postal_code'] ?? '',
    );
  }
}

class OrderItem {
  final String productId;
  final int quantity;
  final double unitPrice;
  final double taxRate;
  final double discountPercent;
  final double total;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.taxRate,
    required this.discountPercent,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      taxRate: (json['tax_rate'] ?? 0).toDouble(),
      discountPercent: (json['discount_percent'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}
