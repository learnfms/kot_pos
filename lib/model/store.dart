class Store {
  final int? id;
  final String? storeName;
  final String storeEmail;
  final String? storePhone;

  Store({
    this.id,
    this.storeName,
    required this.storeEmail,
    this.storePhone,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      storeName: json['name'],
      storeEmail: json['email'],
      storePhone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'email': storeEmail,
      'phone': storePhone,
    };
  }
}
