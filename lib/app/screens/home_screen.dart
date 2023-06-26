import 'package:chat_app/app/screens/login_screen.dart';
import 'package:chat_app/app/services/firebase_methods.dart';
import 'package:chat_app/app/widgets/common_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: commonButton(
            onPress: () {
              logOut().then((value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false));
            },
            buttonTxt: 'Logout'.toUpperCase()),
      ),
    );
  }
}
