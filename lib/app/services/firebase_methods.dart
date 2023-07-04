import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

/// create user on firebase
Future<User?> createAccount({
  required String name,
  required String email,
  required String password,
  required String profileUrl,
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  try {
    User? user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      // Get the device token
      String? deviceToken = await _firebaseMessaging.getToken();
      user.updateDisplayName(name);
      user.updatePhotoURL(profileUrl);
      await firestore.collection('users').doc(auth.currentUser?.uid).set(
        {
          "name": name,
          "email": email,
          "profileUrl":profileUrl,
          "status": "unavailable",
          "uid": auth.currentUser?.uid,
          "lastMsg": '',
          "deviceToken": deviceToken,
          "isTyping":false,
        },
      );
      return user;
    } else {
      print('user not created');
      return user;
    }
  } catch (e) {
    print(e);
  }

  return null;
}

/// login user
Future<User?> login({required String email, required String password}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User? user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print('user login');
      return user;
    } else {
      print('user not login');
      return user;
    }
  } catch (e) {
    print(e);
  }
  return null;
}

/// logout user
Future logOut() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signOut();
  } catch (e) {
    print(e);
  }
}

// Send a notification
Future<void> sendNotificationUsingFirebase(
    String deviceToken, String message, String senderName) async {
  await http
      .post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAQOfLhSo:APA91bE2QthI8d8lFj8ExfIKL9mTahDfWU0YEYhAXR8cg4nSYaUcs9lDFZKOaD7fcJPpKiDBRs3Qn8f0QtCUDxAkD7DI-6keItusbS_YUTywI88IArssXu-qnmUvTzAz1yyxqot-gV0w',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': message,
          'title': senderName,
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'title': senderName,
          'body': message,
        },
        'to': deviceToken,
      },
    ),
  )
      .then((value) {
    print('value ::${value.body}');
  });
  // await _firebaseMessaging.sendMessage(
  //   // messageId: deviceToken,
  //   // to: deviceToken,
  //   messageType: 'Text',
  //   data: {
  //     'title': 'New Message',
  //     'body': message,
  //   },
  // ).catchError((e) {
  //   print('exception :: $e');
  // });
}
