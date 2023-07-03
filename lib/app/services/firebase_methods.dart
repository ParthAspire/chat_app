import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// create user on firebase
Future<User?> createAccount({
  required String name,
  required String email,
  required String password,
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
      await firestore.collection('users').doc(auth.currentUser?.uid).set(
        {
          "name": name,
          "email": email,
          "status": "unavailable",
          "uid": auth.currentUser?.uid,
          "lastMsg": '',
          "deviceToken": deviceToken,
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

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// Send a notification
Future<void> sendNotification(String deviceToken, String message) async {
  await _firebaseMessaging.sendMessage(
    messageId: deviceToken,to: deviceToken,messageType: 'Text',
    data: {
      'title': 'New Message',
      'body': message,
    },
  );
}
