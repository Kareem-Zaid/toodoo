import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:toodoo/task_model.dart';

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
    // sound: RawResourceAndroidNotificationSound('prayer_time'),
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

    // Add "app_icon.png" inside drawable to avoid exception
    // android/app/src/main/res/drawable/app_icon.png
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

  Future<void> cancelNotification(int id) async {
    if (!Platform.isAndroid) return;

    await _flutterLocalNotificationsPlugin.cancel(id);
    debugPrint('Notification with id = $id canceled');
    final pendingNotifs =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    debugPrint('Pending notifs count after canceling: ${pendingNotifs.length}');
  }

  Future<void> cancelAllNotifications() async {
    if (!Platform.isAndroid) return;

    await _flutterLocalNotificationsPlugin.cancelAll();
    debugPrint('All notifications canceled');
    final pendingNotifs =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    debugPrint('Pending notifs count after canceling: ${pendingNotifs.length}');
  }

  // Schedule notifications at a specific date and time, with repeat option [1]
  Future<void> scheduleTaskReminder(Task task) async {
    if (!Platform.isAndroid) return;

    final tz.TZDateTime tzDateTime =
        tz.TZDateTime.from(task.dateTime, tz.local);
    const String title = 'Task Reminder';

    if (task.dateTime.isAfter(DateTime.now())) {
      // Cancel task old reminder whatever its value
      await cancelNotification(task.id);

      if (task.isDone || !task.isReminderOn) {
        debugPrint('Task is either marked as done or reminder is off');
        Fluttertoast.showToast(
            msg: 'Task is either marked as done or reminder is off');
        return;
      }

      // As per selected "task.repeat", one of two repeat properties occurs
      RepeatInterval? repeatInterval; // Hourly, daily, and weekly options
      DateTimeComponents? dateTimeComponents; // Monthly and yearly options

      switch (task.repeat) {
        case Repeat.off:
          break;
        case Repeat.hourly:
          // repeatInterval = RepeatInterval.hourly;
          repeatInterval = RepeatInterval.everyMinute;
          break;
        case Repeat.daily:
          repeatInterval = RepeatInterval.daily;

          break;
        case Repeat.weekly:
          repeatInterval = RepeatInterval.weekly;
          break;
        case Repeat.monthly:
          dateTimeComponents = DateTimeComponents.dayOfMonthAndTime;
          break;
        case Repeat.yearly:
          dateTimeComponents = DateTimeComponents.dateAndTime;
          break;
      }

      // Schedule task new reminder without checking old one
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        task.id, title, task.name, tzDateTime, _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: dateTimeComponents, // Periodical repeat
      );

      if (repeatInterval != null) {
        await _flutterLocalNotificationsPlugin.periodicallyShow(
          task.id, title, task.name, repeatInterval, // Periodical repeat also
          _notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }

      debugPrint(
          'Done scheduling a reminder with id = $task.id at $tzDateTime');
      final pendingNotifs2 =
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
      debugPrint('Total pending notifs count: ${pendingNotifs2.length}');
    } else {
      debugPrint('Set a future date/time');
      Fluttertoast.showToast(msg: 'Set a future date/time');
    }
  }
}
