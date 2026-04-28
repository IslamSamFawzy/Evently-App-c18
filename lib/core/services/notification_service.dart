import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Android initialization settings
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // iOS initialization settings
      const ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const settings = InitializationSettings(
        android: android,
        iOS: ios,
      );

      // Initialize notifications
      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (response) async {
          debugPrint('Notification clicked: ${response.actionId}');
          if (response.actionId == 'snooze') {
            final newTime = DateTime.now().add(const Duration(minutes: 5));

            await scheduleNotification(
              id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              title: "Snoozed Event",
              body: "Reminder after snooze",
              dateTime: newTime,
            );
          }
        },
      );

      // Create Android notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'event_channel',
        'Events',
        description: 'Event notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      // Create notification channel for Android
      await _notifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Request permissions for Android 13+
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        debugPrint('Android notification permission granted: $granted');
      }

      // Request permissions for iOS
      final iosPlugin = _notifications
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        debugPrint('iOS notification permission granted: $granted');
      }

    } catch (e) {
      debugPrint('Error initializing notifications: $e');
      rethrow;
    }
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    try {
      final scheduledTime = tz.TZDateTime.from(
        dateTime,
        tz.local,
      );

      // Check if the scheduled time is in the future
      if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        debugPrint('Cannot schedule notification in the past');
        return;
      }

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'event_channel',
            'Events',
            channelDescription: 'Event notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            actions: [
              AndroidNotificationAction(
                'snooze',
                'Snooze 5 min',
                showsUserInterface: true,
              ),
            ],
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      
      debugPrint('Notification scheduled successfully for: $scheduledTime');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      rethrow;
    }
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    try {
      await _notifications.show(
        0,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'event_channel',
            'Events',
            channelDescription: 'Event notifications',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      debugPrint('Instant notification shown successfully');
    } catch (e) {
      debugPrint('Error showing instant notification: $e');
      rethrow;
    }
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
      debugPrint('Notification cancelled: $id');
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
      rethrow;
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      debugPrint('All notifications cancelled');
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
      rethrow;
    }
  }

  static Future<bool> hasPermission() async {
    try {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        return await androidPlugin.areNotificationsEnabled() ?? false;
      }
      
      final iosPlugin = _notifications
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      
      if (iosPlugin != null) {
        return true; // iOS permissions are checked during initialization
      }
      
      return false;
    } catch (e) {
      debugPrint('Error checking notification permissions: $e');
      return false;
    }
  }
}