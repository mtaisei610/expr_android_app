import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart'; 
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  Future<void> initialize() async {
    
    tzdata.initializeTimeZones();
    try {
      
      final TimezoneInfo lTz = await FlutterTimezone.getLocalTimezone();
      final localTz = lTz.toString();
      tz.setLocalLocation(tz.getLocation(localTz));
    } catch (_) {
      
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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
