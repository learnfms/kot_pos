import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../model/store.dart';

class StoreRepository {
  final String baseUrl = "http://localhost:3000/store";

  // Method to register a store
  Future<void> registerStore({
    required String storeName,
    required String storeAddress,
    required double storeLatitude,
    required double storeLongitude,
    required String storeEmail,
    required String storePhone,
    required String storePassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/registerStore'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'storeName': storeName,
          'storeAddress': storeAddress,
          'storeLatitude': storeLatitude,
          'storeLongitude': storeLongitude,
          'storeEmail': storeEmail,
          'storePhone': storePhone,
          'storePassword': storePassword,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        Get.snackbar('Success', responseData['message']);
      } else {
        final responseData = jsonDecode(response.body);
        Get.snackbar('Error', responseData['error']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to register store');
    }
  }

  // Method to log in a store
  Future<Store?> loginStore({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/loginStore'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'storeEmail': email, 'storePassword': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Store.fromJson(responseData['store']);
      } else if (response.statusCode == 401) {
        Get.snackbar('Login Error', 'Invalid credentials');
      } else {
        Get.snackbar('Error', 'Failed to log in');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    }
    return null;
  }
}