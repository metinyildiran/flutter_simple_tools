import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static late final SharedPreferences instance;

  // Call this function in initState()
  static Future<SharedPreferences> init() async => instance = await SharedPreferences.getInstance();

  // Getters and Setters
  static String getString(String key, [String? defValue]) {
    return instance.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) {
    return instance.setString(key, value);
  }

  static bool getBool(String key, [bool? defValue]) {
    return instance.getBool(key) ?? defValue ?? false;
  }

  static Future<bool> setBool(String key, bool value) {
    return instance.setBool(key, value);
  }
}
