import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

// If not added, an exception occurs
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('onDidReceiveBackgroundNotifResp: $notificationResponse');
}

class LocalNotifsService {
  // int id = 0;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'TR',
    'Task Reminders',
    channelDescription: 'Channel of all scheduled task reminders',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    // android/app/src/main/res/raw/sound_file_name
    sound: RawResourceAndroidNotificationSound('prayer_time'),
  );

  final NotificationDetails _notificationDetails =
      const NotificationDetails(android: _androidNotificationDetails);

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) return;

    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> initLocalNotifs() async {
    if (!Platform.isAndroid) return;

    WidgetsFlutterBinding.ensureInitialized();
    await _configureLocalTimeZone();

    // android/app/src/main/res/drawable/app_icon.png
    // If not added, an exception occurs
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          // Next callback fires when a notification has been tapped on
          (NotificationResponse notificationResponse) {
        debugPrint('onDidReceiveNotificationResponse: $notificationResponse');
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  // Request permissions either on the initialization of the first page
  // or on activating (switching on) notifications from settings
  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      // Check whether permission is granted
      bool granted = await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      // Request permission for notifications if not granted yet
      if (!granted) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>();

        await androidImplementation?.requestNotificationsPermission();
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    if (!Platform.isAndroid) return;

    await _flutterLocalNotificationsPlugin.cancelAll();
    debugPrint('Notifications canceled');
    final pendingNotifs =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    debugPrint('Pending notifs count after canceling: ${pendingNotifs.length}');
  }

  // Schedule notification to appear at a specific date and time
  Future<void> _zonedScheduleNotification(
      int id, String title, String body, tz.TZDateTime dateTime) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id, title, body, dateTime, _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      matchDateTimeComponents: DateTimeComponents.dateAndTime, // Repeat yearly
    );
  }

  // Repeat notifications daily
  Future<void> _repeatNotification() async {
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'repeating title',
      'repeating body',
      RepeatInterval.daily,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleTaskReminder(DateTime dateTime) async {
    if (!Platform.isAndroid) return;

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // This should include the logic of scheduling and repetition
    _repeatNotification();

    // ID should be item-tied so that you can cancel selected item
    _zonedScheduleNotification(
      0, 'title', 'body',
      // Set scheduled notification date and time
      tz.TZDateTime(tz.local, now.year, now.month, now.day /* , hours, mins */),
    );

    debugPrint('Done scheduling a reminder at $now');
    final pendingNotifs =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    debugPrint('Total pending notifs count: ${pendingNotifs.length}');
  }
}
