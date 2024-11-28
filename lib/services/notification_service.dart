import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:leafora/services/get_server_key.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final GetServerKey _getServerKey = GetServerKey();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  // Initialize the NotificationService
  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _setupMessageHandlers();

    final token = await _messaging.getToken();
    print('FCM Token: $token');
  }

  // Request notification permissions
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission status: ${settings.authorizationStatus}');
  }

  // Setup local notifications
  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tapped
        print('Notification tapped: ${details.payload}');
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  // Background handler for FCM messages
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await NotificationService.instance.setupFlutterNotifications();
    await NotificationService.instance.showNotification(message);
  }

  // Show a local notification
  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  // Send push notifications to multiple tokens
  Future<void> sendPushNotification(String token, Map<String, dynamic> scheduleData) async {
    try {
      final String serverKey = await _getServerKey.getServerKeyToken();
      final Uri url = Uri.parse("https://fcm.googleapis.com/v1/projects/bus-koi-6d51b/messages:send");

      // Construct the notification payload
      Map<String, dynamic> notificationData = {
        "message": {
          "notification": {
            "title": "New Schedule Added",
            "body": "A new schedule has been added. Check it now!",
          },
          "data": scheduleData,
          "token": token, // Send to individual token
        },
      };

      // Headers for the FCM API
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $serverKey",
      };

      // Send POST request to FCM
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(notificationData),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully to token: $token");
      } else {
        final responseBody = json.decode(response.body);
        print("Failed to send notification to token: $token, Response: $responseBody");

        // Handle invalid tokens
        if (responseBody["error"]?["details"] != null) {
          for (var detail in responseBody["error"]["details"]) {
            if (detail["@type"] == "type.googleapis.com/google.rpc.BadRequest" &&
                detail["fieldViolations"] != null) {
              for (var violation in detail["fieldViolations"]) {
                if (violation["field"] == "message.token" &&
                    violation["description"] == "Invalid registration token") {
                  throw Exception("Invalid registration token");
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error sending notification to token: $e");
      rethrow; // Rethrow the exception to handle invalid tokens in the calling method
    }
  }


  // Setup message handlers
  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      // Navigate to chat screen
      print('Open chat screen with data: ${message.data}');
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
