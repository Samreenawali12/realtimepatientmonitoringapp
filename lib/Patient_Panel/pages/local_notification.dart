import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/docRequest.dart';
import 'package:dbtest/Patient_Panel/pages/Requesteddoc.dart';
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
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    //await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void selectNotification(String? payload) {
    // if (user == "doctor") {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => docRequest()));
    // } else {
    //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    //     return Requesteddoc();
    //   }));
    // }
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
            priority: Priority.max,
            icon: '@drawable/ic_launcher'),
      ),
    );
  }
}
