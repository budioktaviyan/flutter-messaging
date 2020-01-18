import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    messaging.getToken().then((String token) async {
      print("FCM Token : $token");
    });

    messaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print(message);
        },
        onBackgroundMessage: backgroundMessageHandler,
        onResume: (Map<String, dynamic> message) async {
          print(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print(message);
        });
  }
}

Future backgroundMessageHandler(Map<String, dynamic> message) async {
  print(message);
}
