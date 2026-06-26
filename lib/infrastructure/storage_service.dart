import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyCustomTime = 'custom_time_minutes';
  static const String _keyAlarmSound = 'alarm_sound_path';

  // 1. SettingsNotifierで通常通り「StorageService()」と呼べるように未命名コンストラクタを定義
  StorageService();

  // 2. SharedPreferencesインスタンスを取得するための共通プライベートヘルパーメソッド
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<int> getCustomTime() async {
    final prefs = await _getPrefs();
    final v = prefs.getInt(_keyCustomTime);
    return v ?? 5;
  }

  Future<void> saveCustomTime(int minutes) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_keyCustomTime, minutes);
  }

  Future<String> getAlarmSound() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyAlarmSound) ?? 'assets/sounds/default_alarm.mp3';
  }

  Future<void> saveAlarmSound(String soundPath) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyAlarmSound, soundPath);
  }
}
