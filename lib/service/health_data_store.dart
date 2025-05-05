import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HealthDataStore {
  static late SharedPreferences _prefs;
  static const _key = 'health_data';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<Map<String, dynamic>> getAllEntries() {
    if (!_prefs.containsKey(_key)) return [];

    final jsonString = _prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print("Lỗi khi decode dữ liệu: \$e");
    }

    return [];
  }

  static Future<void> saveEntry(Map<String, dynamic> entry) async {
    final allEntries = getAllEntries();
    allEntries.add(entry);
    final jsonString = jsonEncode(allEntries);
    await _prefs.setString(_key, jsonString);
  }

  static Future<void> clearAll() async {
    await _prefs.remove(_key);
  }
}
