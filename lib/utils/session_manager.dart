import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveUser(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
    prefs.setString('userEmail', email);
  }

  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userName': prefs.getString('userName'),
      'userEmail': prefs.getString('userEmail'),
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userName');
  }
}
