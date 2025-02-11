import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/store.dart';

class StoreDataManager {
  static const String _storeKey = 'storeJson';

  static Future<Store?> loadStoreData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storeJson = prefs.getString(_storeKey);
      if (storeJson != null) {
        final Map<String, dynamic> storeMap = json.decode(storeJson);
        return Store.fromJson(storeMap);
      }
    } catch (e) {
      print('Error loading store data: $e');
    }
    return null;
  }

  static Future<void> saveStoreData(Store store) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storeJson = json.encode(store.toJson());
      await prefs.setString(_storeKey, storeJson);
    } catch (e) {
      print('Error saving store data: $e');
    }
  }

  static Future<bool> hasStoreData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_storeKey);
    } catch (e) {
      print('Error checking store data: $e');
      return false;
    }
  }

  static Future<void> removeStoreData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storeKey);
    } catch (e) {
      print('Error removing store data: $e');
    }
  }
}
