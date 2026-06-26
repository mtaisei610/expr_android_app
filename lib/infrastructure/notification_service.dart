import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  Future<void> initialize() async {
    // Initialize timezone package
    tzdata.initializeTimeZones();
    try {
      final String localTz = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTz));
    } catch (_) {
      // Fallback to UTC if timezone lookup fails
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);
  }

  Future<void> scheduleAlarm(int seconds, String soundPath) async {
    final scheduled =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );
    const iosDetails = DarwinNotificationDetails(presentSound: true);
    const platform =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      0,
      'Timer',
      'Time is up',
      scheduled,
      platform,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
      payload: soundPath,
    );
  }

  Future<void> cancelAlarm() async {
    await _plugin.cancelAll();
  }
}
