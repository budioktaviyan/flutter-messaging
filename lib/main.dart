import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var localMessaging = new FlutterLocalNotificationsPlugin();

void main() => runApp(App());

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
  final FirebaseMessaging messaging = FirebaseMessaging();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    super.initState();
    _configureMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void _configureMessaging() {
    var android =
        new AndroidInitializationSettings('@drawable/ic_notification');
    var iOS = new IOSInitializationSettings();
    var settings = new InitializationSettings(android, iOS);

    localMessaging.initialize(
      settings,
      onSelectNotification: _onSelectNotification,
    );

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

  localMessaging.show(
    1,
    message["data"]["title"],
    message["data"]["body"],
    notificationDetails,
    payload: message["data"]["payload"],
  );
}
