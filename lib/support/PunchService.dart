import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PunchService {
  static const String _key = "punch_log";

  // Get today's date as a string
  String _today() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<Map<String, dynamic>> _getPunchMap() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      return json.decode(raw);
    }
    return {};
  }

  Future<void> _savePunchMap(Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(map));
  }

  Future<void> punchIn() async {
    final map = await _getPunchMap();
    final today = _today();
    final now = DateFormat('HH:mm').format(DateTime.now());

    map[today] = {
      "punchIn": now,
      "dateTime_in":DateTime.now().toString(),
      "punchOut": map[today]?["punchOut"], // preserve punch out if exists
    };

    await _savePunchMap(map);
  }

  Future<void> punchOut() async {
    final map = await _getPunchMap();
    final today = _today();
    final now = DateFormat('HH:mm').format(DateTime.now());
     print(today.toString());
    map[today] = {
      "punchIn": map[today]?["punchIn"],
      "punchOut": now,
      "dateTime_out":DateTime.now().toString(),
      "duration":""
    };

    await _savePunchMap(map);
  }

  Future<Map<String, dynamic>?> getTodayPunch() async {
    final map = await _getPunchMap();
    return map[_today()];
  }

  Future<Map<String, dynamic>> getAllPunches() async {
    return await _getPunchMap();
  }

  Future<void> clearPunchData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
