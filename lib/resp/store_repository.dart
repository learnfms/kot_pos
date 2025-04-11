import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../model/store.dart';
import '../shared_preferences/store_data_manager.dart';
import '../screens/welcome_screen.dart';

class StoreRepository {
  final String baseUrl = "http://192.168.68.122:3000/store";

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
      // Validate input
      if (storeName.isEmpty || storeEmail.isEmpty || storePassword.isEmpty) {
        Get.snackbar('Validation Error', 'Please fill all required fields');
        return;
      }
      // Add more specific validation if needed
      
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

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        Get.snackbar('Success', responseData['message']);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final responseData = jsonDecode(response.body);
        Get.snackbar('Error', 'Client error: ${responseData['error'] ?? responseData['message'] ?? "Unknown error"}');
      } else if (response.statusCode >= 500) {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      } else {
        Get.snackbar('Error', 'Unexpected error');
      }
    } catch (e) {
      print('Register exception: $e');
      Get.snackbar('Error', 'Failed to register store: $e');
    }
  }

  // Method to log in a store
  Future<Store?> loginStore({
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        Get.snackbar('Validation Error', 'Email and password are required');
        return null;
      }

      // Payload with correct field names
      final Map<String, dynamic> payload = {
        'storeEmail': email,  // Match backend field name
        'storePassword': password,  // Match backend field name
      };

      print('Attempting to log in with email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/loginStore'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final store = Store.fromJson(responseData['store']);
        await StoreDataManager.saveStoreData(store); // Save store data locally
        print('Login successful, store data saved.');
        return store;
      } else if (response.statusCode == 401) {
        Get.snackbar('Login Error', 'Invalid credentials');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final responseData = jsonDecode(response.body);
        Get.snackbar('Error', 'Client error: ${responseData['error'] ?? "Unknown error"}');
      } else if (response.statusCode >= 500) {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      } else {
        Get.snackbar('Error', 'Unexpected error');
      }
    } catch (e) {
      print('Login exception: $e');
      print('Exception during login: ${e.toString()}');
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
    return null;
  }

  Future<void> logout() async {
    await StoreDataManager.removeStoreData();
    Get.off(() => const WelcomeScreen());
  }
}
