import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dump/Model/UserData.dart';
import 'package:dump/locator.dart';
import 'package:dump/main.dart';
import 'package:dump/services/authServices.dart';
import 'package:dump/services/dialogService.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final DialogService _dialogService = locator<DialogService>();
  final AuthService _authService = locator<AuthService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  UserData get currentUser => _authService.currentUser;
  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  initialiseLocalnotifiction() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: "@mipmap/ic_launcher")));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessageOpenedAPP event was published.");
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        _dialogService.dialog(
          notification.title,
          notification.body,
        );
      }
    });
  }

  void updateToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    print("sss userId: ${currentUser.userId} token $token");
    FirebaseFirestore.instance
        .collection("ResidentCredentials")
        .doc(currentUser.userId)
        .update({"AndroidToken": token});
  }

  void showNotification(title, body) {
    flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high)));
  }
}
