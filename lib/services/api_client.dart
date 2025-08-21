import 'dart:developer';
import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'http://160.30.21.68/api/v1';
  
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    // Request interceptor for logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('[API] ${options.method.toUpperCase()} ${options.uri}');
          if (options.queryParameters.isNotEmpty) {
            log('[API] Params: ${options.queryParameters}');
          }
          if (options.data != null) {
            log('[API] Data: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          log('[API] ${response.statusCode} ${response.requestOptions.uri}');
          log('[API] Response headers: ${response.headers}');
          handler.next(response);
        },
        onError: (error, handler) {
          log('[API] Error: ${error.message}');
          log('[API] Error code: ${error.response?.statusCode}');
          
          if (error.response != null) {
            log('[API] Response status: ${error.response?.statusCode}');
            log('[API] Response data: ${error.response?.data}');
            
            if (error.response?.data is Map && 
                error.response?.data['message'] != null) {
              log('[API] Server error message: ${error.response?.data['message']}');
            }
          } else {
            log('[API] Request made but no response: ${error.requestOptions}');
          }
          
          handler.next(error);
        },
      ),
    );
  }

  // GET request
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // PATCH request
  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }
}
