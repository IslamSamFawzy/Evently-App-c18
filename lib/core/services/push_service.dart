import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

class PushService {
  static Future<void> init() async {
    try {
      final fcm = FirebaseMessaging.instance;

      // Request permission for iOS
      final settings = await fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('FCM permission status: ${settings.authorizationStatus}');

      // Get FCM token
      String? token = await fcm.getToken();
      debugPrint("FCM Token: $token");

      // Listen for messages when app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Received message: ${message.messageId}');
        debugPrint('Notification: ${message.notification?.title}');
        
        NotificationService.showInstantNotification(
          title: message.notification?.title ?? "Event",
          body: message.notification?.body ?? "",
        );
      });

      // Handle messages when app is in background but opened
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('Message opened app: ${message.messageId}');
      });

      // Handle messages when app is completely closed
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('Initial message: ${initialMessage.messageId}');
      }

    } catch (e) {
      debugPrint('Error initializing push notifications: $e');
      rethrow;
    }
  }

  static Future<String?> getToken() async {
    try {
      final fcm = FirebaseMessaging.instance;
      return await fcm.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }
}