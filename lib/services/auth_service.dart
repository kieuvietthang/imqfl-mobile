import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:iqiyi_fl/models/user_model.dart';
import 'package:iqiyi_fl/services/api_client.dart';

import '../models/login_response.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<UserModel?> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        "/auth/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Register success: ${response.data}");
        return UserModel.fromJson(response.data!);
      } else {
        log("Register failed with code: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      log("DioException Register: ${e.response?.data}");
      rethrow;
    } catch (e) {
      log("Register error: $e");
      rethrow;
    }
  }

  Future<LoginResponse?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _apiClient.post<Map<String, dynamic>>(
        "/login",
        data: {
          'email': email,
          'password': password,
        },
      );
      if (res.statusCode == 200) {
        final body = res.data!;
        log("Login success: $body");
        return LoginResponse.fromJson(body);
      } else {
        log("Login failed with code: ${res.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      log("DioException Login: ${e.response?.data}");
      rethrow;
    } catch (e) {
      log("Login error: $e");
      rethrow;
    }
  }
}