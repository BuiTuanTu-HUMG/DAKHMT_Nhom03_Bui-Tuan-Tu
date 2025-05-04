import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HealthDataStore {
  static late SharedPreferences _prefs;
  static const String _key = 'health_data';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<Map<String, dynamic>> getAllEntries() {
    if (!_prefs.containsKey(_key)) return [];
    final jsonString = _prefs.getString(_key);
    final decoded = jsonDecode(jsonString!);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> saveEntry(Map<String, dynamic> entry) async {
    final existing = getAllEntries();
    existing.add(entry);
    await _prefs.setString(_key, jsonEncode(existing));
  }

  static Future<void> clearAll() async {
    await _prefs.remove(_key);
  }
}