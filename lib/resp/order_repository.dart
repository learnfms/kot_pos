import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/order.dart';

class OrderRepository {
  final String baseUrl = 'http://192.168.1.5:3000/store';

  Future<void> createOrder(int tableNumber, List<OrderItem> items) async {
    final response = await http.post(
      Uri.parse('$baseUrl/createOrder'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tableNumber': tableNumber,
        'items': items.map((item) => item.toJson()).toList(),
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create order');
    }
  }

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/getOrders'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['orders'];
      return data.map((orderJson) => Order.fromJson(orderJson)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateOrderStatus/$orderId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order status');
    }
  }
}
