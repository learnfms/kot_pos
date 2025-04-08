import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/menu_item.dart';

class MenuRepository {
  final String baseUrl = 'http://192.168.1.3:3000/store';

  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await http.get(Uri.parse('$baseUrl/getMenuItems'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['menuItems'];
      return data.map((itemJson) => MenuItem.fromJson(itemJson)).toList();
    } else {
      throw Exception('Failed to fetch menu items');
    }
  }

  Future<void> addMenuItem(MenuItem item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addMenuItem'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add menu item');
    }
  }

  Future<void> updateMenuItem(MenuItem item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateMenuItem/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update menu item');
    }
  }

  Future<void> deleteMenuItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/deleteMenuItem/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete menu item');
    }
  }
}
