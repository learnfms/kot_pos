import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/store.dart';

class StoreDataManager {
  static const String _storeKey = 'storeJson';

  static Future<Store?> loadStoreData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('Loading store data...');
      final storeJson = prefs.getString(_storeKey);
      if (storeJson != null) {
        final Map<String, dynamic> storeMap = json.decode(storeJson);
        print('Store data loaded: \${storeMap.toString()}');
        return Store.fromJson(storeMap);
      }
    } catch (e) {
      print('Error loading store data: $e');
      // Add additional error handling logic here
    }
    return null;
  }

  static Future<void> saveStoreData(Store store) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('Saving store data: \${store.toJson().toString()}');
      final storeJson = json.encode(store.toJson());
      await prefs.setString(_storeKey, storeJson);
      print('Store data saved successfully.');
    } catch (e) {
      print('Error saving store data: $e');
      // Add additional error handling logic here
    }
  }

  static Future<bool> hasStoreData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('Checking for store data...');
      return prefs.containsKey(_storeKey);
    } catch (e) {
      print('Error checking store data: $e');
      // Add additional error handling logic here
      return false;
    }
  }

  static Future<void> removeStoreData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('Removing store data...');
      await prefs.remove(_storeKey);
      print('Store data removed successfully.');
    } catch (e) {
      print('Error removing store data: $e');
      // Add additional error handling logic here
    }
  }
}
