class Store {
  final int? id;
  final String? storeName; // Made optional
  final String? storeAddress; // Made optional
  final double? storeLatitude; // Made optional
  final double? storeLongitude; // Made optional
  final String storeEmail;
  final String? storePhone; // Made optional
  final String? storePassword; // Optional field

  Store({
    this.id,
    this.storeName,
    this.storeAddress,
    this.storeLatitude,
    this.storeLongitude,
    required this.storeEmail,
    this.storePhone,
    this.storePassword,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    // Handle missing fields gracefully
    return Store(
      id: json['id'],
      storeName: json['store_name'], // Optional field
      storeAddress: json['store_address'], // Optional field
      storeLatitude: json.containsKey('store_latitude') ? (json['store_latitude'] as num).toDouble() : null,
      storeLongitude: json.containsKey('store_longitude') ? (json['store_longitude'] as num).toDouble() : null,
      storeEmail: json['email'] ?? '', // Required field (use 'email' instead of 'store_email' based on backend response)
      storePhone: json['phone'], // Optional field
      storePassword: json['store_password'], // Optional field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'store_address': storeAddress,
      'store_latitude': storeLatitude,
      'store_longitude': storeLongitude,
      'email': storeEmail, // Use 'email' instead of 'store_email' for consistency with backend response
      'phone': storePhone, // Optional field
      if (storePassword != null) 'store_password': storePassword, // Include only if not null
    };
  }
}
