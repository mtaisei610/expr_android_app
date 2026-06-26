import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyCustomTime = 'custom_time_minutes';
  static const String _keyAlarmSound = 'alarm_sound_path';

  final SharedPreferences _prefs;

  StorageService._(this._prefs);

  static Future<StorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService._(prefs);
  }

  Future<int> getCustomTime() async {
    final v = _prefs.getInt(_keyCustomTime);
    return v ?? 5;
  }

  Future<void> saveCustomTime(int minutes) async {
    await _prefs.setInt(_keyCustomTime, minutes);
  }

  Future<String> getAlarmSound() async {
    return _prefs.getString(_keyAlarmSound) ??
        'assets/sounds/default_alarm.mp3';
  }

  Future<void> saveAlarmSound(String soundPath) async {
    await _prefs.setString(_keyAlarmSound, soundPath);
  }
}
