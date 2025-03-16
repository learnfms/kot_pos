class Store {
  final String? id;
  final String storeName;
  final String storeAddress;
  final double storeLatitude;
  final double storeLongitude;
  final String storeEmail;
  final String storePhone;
  final String? storePassword; // Optional, as it shouldn't be returned from the server

  Store({
    this.id,
    required this.storeName,
    required this.storeAddress,
    required this.storeLatitude,
    required this.storeLongitude,
    required this.storeEmail,
    required this.storePhone,
    this.storePassword,
  }) {
    if (storeName.isEmpty ||
        storeAddress.isEmpty ||
        storeEmail.isEmpty ||
        storePhone.isEmpty) {
      throw Exception('Required fields cannot be empty');
    }
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('storeName') ||
        !json.containsKey('storeAddress') ||
        !json.containsKey('storeLatitude') ||
        !json.containsKey('storeLongitude') ||
        !json.containsKey('storeEmail') ||
        !json.containsKey('storePhone')) {
      throw Exception('Missing required fields in JSON');
    }

    return Store(
      id: json['id'],
      storeName: json['storeName'],
      storeAddress: json['storeAddress'],
      storeLatitude: json['storeLatitude'].toDouble(),
      storeLongitude: json['storeLongitude'].toDouble(),
      storeEmail: json['storeEmail'],
      storePhone: json['storePhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'storeLatitude': storeLatitude,
      'storeLongitude': storeLongitude,
      'storeEmail': storeEmail,
      'storePhone': storePhone,
      if (storePassword != null) 'storePassword': storePassword,
    };
  }

  Store copyWith({
    String? id,
    String? storeName,
    String? storeAddress,
    double? storeLatitude,
    double? storeLongitude,
    String? storeEmail,
    String? storePhone,
    String? storePassword,
  }) {
    return Store(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      storeLatitude: storeLatitude ?? this.storeLatitude,
      storeLongitude: storeLongitude ?? this.storeLongitude,
      storeEmail: storeEmail ?? this.storeEmail,
      storePhone: storePhone ?? this.storePhone,
      storePassword: storePassword ?? this.storePassword,
    );
  }
}
