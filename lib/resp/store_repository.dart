import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StoreRepository {
  final String serverUrl = "http://10.0.2.2:3000/store";

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
        Uri.parse('$serverUrl/registerStore'),
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
        Get.snackbar('Registration Successful', responseData['message']);
      } else {
        final responseData = jsonDecode(response.body);
        Get.snackbar('Registration Failed', responseData['error']);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }
}
