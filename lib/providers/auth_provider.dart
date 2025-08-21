import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = true;
  String? _token;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await StorageService.getToken();
      _isLoggedIn = token != null && token.isNotEmpty;
      _token = token;
    } catch (e) {
      _isLoggedIn = false;
      _token = null;
      _errorMessage = 'Error checking login status: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String token) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await StorageService.saveToken(token);
      if (success) {
        _isLoggedIn = true;
        _token = token;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to save login token';
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      final success = await StorageService.removeToken();
      if (success) {
        _isLoggedIn = false;
        _token = null;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to logout';
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Skip login for demo purposes
  void skipLogin() {
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }
}
