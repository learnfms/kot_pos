import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kot_pos/core/constants/app_constants.dart';
import 'package:kot_pos/core/errors/failures.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;

  ApiClient()
      : _dio = Dio(BaseOptions(
          baseUrl: dotenv.env['API_BASE_URL'] ?? '',
          connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        )),
        _logger = Logger();

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      _logger.i('GET $path: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      _logger.e('GET $path error: ${e.message}');
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      _logger.i('POST $path: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      _logger.e('POST $path error: ${e.message}');
      throw _handleDioError(e);
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return ServerFailure(
          message: error.response?.data['message'] ?? 'Server error occurred',
          code: error.response?.statusCode.toString(),
        );
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'Request cancelled');
      default:
        return const NetworkFailure(
          message: 'Network error occurred. Please try again.',
        );
    }
  }
} 