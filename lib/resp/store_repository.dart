import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../model/store.dart';
import '../shared_preferences/store_data_manager.dart';
import '../screens/welcome_screen.dart';

class StoreRepository {
  final String baseUrl = "http://192.168.1.3:3000/store";

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
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final responseData = jsonDecode(response.body);
        Get.snackbar('Error', 'Client error: ${responseData['error']}');
      } else if (response.statusCode >= 500) {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      } else {
        Get.snackbar('Error', 'Unexpected error');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to register store: $e');
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
        final store = Store.fromJson(responseData['store']);
        await StoreDataManager.saveStoreData(store); // Save store data
        return store;
      } else if (response.statusCode == 401) {
        Get.snackbar('Login Error', 'Invalid credentials');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final responseData = jsonDecode(response.body);
        Get.snackbar('Error', 'Client error: ${responseData['error']}');
      } else if (response.statusCode >= 500) {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      } else {
        Get.snackbar('Error', 'Unexpected error');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
    return null;
  }

  Future<void> logout() async {
    await StoreDataManager.removeStoreData();
    Get.off(() => const WelcomeScreen());
  }
}
