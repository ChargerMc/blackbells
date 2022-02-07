import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static late FlutterSecureStorage prefs;

  static void configurePrefs() async {
    prefs = const FlutterSecureStorage();
  }

  static Future<String?> getToken() async {
    return await prefs.read(key: 'token');
  }

  static Future<void> saveToken(String token) async {
    await prefs.write(key: 'token', value: token);
  }

  static Future<void> deleteToken() async {
    await prefs.delete(key: 'token');
  }
}
