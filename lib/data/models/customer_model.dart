/// @widget: Customer Model
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Customer data model

class CustomerModel {
  final String id;
  final String name;
  final String type;
  final String category;
  final String contactPerson;
  final String phone;
  final String email;
  final Address physicalAddress;
  final Location location;
  final String taxId;
  final String paymentTerms;
  final double creditLimit;
  final double currentBalance;
  final String territory;
  final String salesPerson;
  final String notes;
  final String lastOrderDate;
  final String orderFrequency;
  final String createdDate;

  CustomerModel({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.physicalAddress,
    required this.location,
    required this.taxId,
    required this.paymentTerms,
    required this.creditLimit,
    required this.currentBalance,
    required this.territory,
    required this.salesPerson,
    required this.notes,
    required this.lastOrderDate,
    required this.orderFrequency,
    required this.createdDate,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      physicalAddress: Address.fromJson(json['physical_address'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      taxId: json['tax_id'] ?? '',
      paymentTerms: json['payment_terms'] ?? '',
      creditLimit: (json['credit_limit'] ?? 0).toDouble(),
      currentBalance: (json['current_balance'] ?? 0).toDouble(),
      territory: json['territory'] ?? '',
      salesPerson: json['sales_person'] ?? '',
      notes: json['notes'] ?? '',
      lastOrderDate: json['last_order_date'] ?? '',
      orderFrequency: json['order_frequency'] ?? '',
      createdDate: json['created_date'] ?? '',
    );
  }

  double get availableCredit => creditLimit - currentBalance;
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

  String get fullAddress => '$building, $street, $city';
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}
