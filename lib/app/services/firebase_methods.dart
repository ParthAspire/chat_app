import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// create user on firebase
Future<User?> createAccount({
  required String name,
  required String email,
  required String password,
}) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    User? user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print('user created');
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
