import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/docRequest.dart';
import 'package:dbtest/Patient_Panel/pages/requested_doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }
  var context;
  var user;
  var patientid;
  var doctorid;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    //await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotification(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            selectNotification(notificationResponse.payload);
            break;
        }
      },
    );
  }

  void selectNotification(response) {
    if (user == "doctor") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const docRequest()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const Requesteddoc();
      }));
    }
  }

  Future<void> showNotification(int id, String title, String body,
      BuildContext context, String user) async {
    this.context = context;
    this.user = user;
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails('channelid', 'channelname',
            importance: Importance.max,
            playSound: true,
            priority: Priority.max,
            fullScreenIntent: true,
            icon: '@drawable/ic_launcher'),
      ),
    );
  }
}

class SpecialNotificationService {
  static final SpecialNotificationService _notificationService =
      SpecialNotificationService._internal();

  factory SpecialNotificationService() {
    return _notificationService;
  }
  var context;
  var user;
  var patientid;
  var doctorid;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SpecialNotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    //await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotification(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            selectNotification(notificationResponse.payload);
            break;
        }
      },
    );
  }

  void selectNotification(response) {
    if (user == "doctor") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const docRequest()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const Requesteddoc();
      }));
    }
  }

  Future<void> showNotification(int id, String title, String body,
      BuildContext context, String user) async {
    this.context = context;
    this.user = user;
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails('channelid', 'channelname',
            importance: Importance.max,
            playSound: true,
            priority: Priority.max,
            icon: '@drawable/ic_launcher'),
      ),
    );
  }
}
