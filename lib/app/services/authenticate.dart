import 'package:chat_app/app/screens/home_screen.dart';
import 'package:chat_app/app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if(auth.currentUser!=null){
      return HomeScreen();
    }
    else{
      return LoginScreen();
    }
  }
}
