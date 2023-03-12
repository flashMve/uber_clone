import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uber_rider_app/Global/constants.dart';

class NotificationsService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  subscribe(String topic) {
    if (!kIsWeb) {
      _firebaseMessaging.subscribeToTopic(topic);
    }
  }

  unSubscribe(String? topic) {
    if (!kIsWeb) {
      _firebaseMessaging.unsubscribeFromTopic(topic!);
    }
  }

  void init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (message.data["rating"] != null) {
          final rideId = getRequestID(message.data);
          final driverId = getDriverID(message.data);

          showRatingDialog(rideId: rideId, driverId: driverId);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("On Message Recieved - ${message.data}");
      if (message.data["rating"] != null) {
        final rideId = getRequestID(message.data);
        final driverId = getDriverID(message.data);

        showRatingDialog(rideId: rideId, driverId: driverId);
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Message Opened here it is : ${message.notification?.body!}");
      if (message.data["rating"] != null) {
        final rideId = getRequestID(message.data);
        final driverId = getDriverID(message.data);

        showRatingDialog(rideId: rideId, driverId: driverId);
      }
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    log('Handling a background message ${message.messageId}');
  }

  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();

      log("Token here => ${token!}");

      return token;
    } catch (e) {
      log('Token Erorr $e');
      return null;
    }
  }

  Stream<String>? onRefreshToken() {
    try {
      return _firebaseMessaging.onTokenRefresh;
    } catch (e) {
      log("Token Erorr $e");
      return null;
    }
  }

  getRequestID(Map<String, dynamic> data) {
    return data['request_id'];
  }

  getDriverID(Map<String, dynamic> data) {
    return data['driver_id'];
  }
}
