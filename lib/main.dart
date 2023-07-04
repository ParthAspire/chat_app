import 'package:chat_app/app/services/authenticate.dart';
import 'package:chat_app/app/services/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  NotificationServices().initializeNotification();
  NotificationServices().checkNotificationPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: Authenticate(),
    );
  }
}
