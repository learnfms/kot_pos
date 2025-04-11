import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get wsBaseUrl => dotenv.env['WS_BASE_URL'] ?? '';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String menuEndpoint = '/menu';
  static const String ordersEndpoint = '/orders';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Pagination
  static const int defaultPageSize = 20;
} 