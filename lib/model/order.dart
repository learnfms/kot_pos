class Order {
  final int id;
  final int tableNumber;
  final String status; // Add the status property
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.tableNumber,
    required this.status, // Initialize the status property
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'], // Match the backend response key
      tableNumber: json['table_number'], // Match the backend response key
      status: json['order_status'], // Match the backend response key
      items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'status': status, // Include the status in JSON serialization
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final String itemName;
  final int quantity;
  final String? specialRequest;

  OrderItem({
    required this.itemName,
    required this.quantity,
    this.specialRequest,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemName: json['item_name'], // Match the backend response key
      quantity: json['quantity'], // Match the backend response key
      specialRequest: json['special_request'], // Match the backend response key
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'quantity': quantity,
      'special_request': specialRequest,
    };
  }
}
