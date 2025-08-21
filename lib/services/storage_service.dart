import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  
  // Save token
  static Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_tokenKey, token);
  }
  
  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  // Remove token
  static Future<bool> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_tokenKey);
  }
  
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  // Save user data
  static Future<bool> saveUser(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_userKey, userData);
  }
  
  // Get user data
  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }
  
  // Clear all data
  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
