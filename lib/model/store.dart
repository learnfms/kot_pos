class Store {
  final int? id;
  final String storeName;
  final String storeAddress;
  final double storeLatitude;
  final double storeLongitude;
  final String storeEmail;
  final String storePhone;
  final String? storePassword;

  Store({
    this.id,
    required this.storeName,
    required this.storeAddress,
    required this.storeLatitude,
    required this.storeLongitude,
    required this.storeEmail,
    required this.storePhone,
    this.storePassword,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('store_name') ||
        !json.containsKey('store_address') ||
        !json.containsKey('store_latitude') ||
        !json.containsKey('store_longitude') ||
        !json.containsKey('store_email') ||
        !json.containsKey('store_phone')) {
      throw Exception('Missing required fields in JSON');
    }

    return Store(
      id: json['id'],
      storeName: json['store_name'],
      storeAddress: json['store_address'],
      storeLatitude: (json['store_latitude'] as num).toDouble(),
      storeLongitude: (json['store_longitude'] as num).toDouble(),
      storeEmail: json['store_email'],
      storePhone: json['store_phone'],
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
      'store_email': storeEmail,
      'store_phone': storePhone,
      if (storePassword != null) 'store_password': storePassword,
    };
  }
}
