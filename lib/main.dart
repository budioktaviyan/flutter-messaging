import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var localMessaging = new FlutterLocalNotificationsPlugin();

void main() {
  runApp(App());
  configureMessaging();
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

void configureMessaging() {
  var android = new AndroidInitializationSettings('@drawable/ic_notification');
  var iOS = IOSInitializationSettings();
  var settings = InitializationSettings(android, iOS);

  localMessaging.initialize(
    settings,
    onSelectNotification: _onSelectNotification,
  );

  final FirebaseMessaging messaging = FirebaseMessaging();
  messaging.getToken().then((String token) async {
    print("FCM Token : $token");
  });

  messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: Platform.isIOS ? null : backgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      });
}

Future _onSelectNotification(String data) async {
  print("onSelectNotification: $data");
}

Future backgroundMessageHandler(Map<String, dynamic> message) async {
  var android = new AndroidNotificationDetails(
    'messaging',
    'Messaging',
    'Firebase Cloud Messaging example for Flutter',
    importance: Importance.Max,
    priority: Priority.High,
  );
  var iOS = new IOSNotificationDetails();
  var notificationDetails = NotificationDetails(android, iOS);

  int id = int.tryParse(message["data"]["id"].toString()) ?? 1;
  localMessaging.show(
    id,
    message["data"]["title"],
    message["data"]["body"],
    notificationDetails,
    payload: message["data"]["data"],
  );
}
