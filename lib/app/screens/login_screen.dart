import 'package:chat_app/app/screens/home_screen.dart';
import 'package:chat_app/app/screens/sign_up_screen.dart';
import 'package:chat_app/app/services/firebase_methods.dart';
import 'package:chat_app/app/widgets/common_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Login'.toUpperCase()),
          ),
          body: Column(
            children: [
              /// email textfield
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )),
              ),

              /// password textfield
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                    controller: password,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )),
              ),

              commonButton(
                onPress: () {
                  login(email: email.text, password: password.text).then(
                    (value) {
                      if (value != null) {
                        setState(() {
                          print('values ::: ${value.email}');
                        });
                        ;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  );
                },
                buttonTxt: 'Login'.toUpperCase(),
              ),

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                  },
                  child: Text('Create Account'.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
