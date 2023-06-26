import 'package:chat_app/app/screens/login_screen.dart';
import 'package:chat_app/app/services/firebase_methods.dart';
import 'package:chat_app/app/widgets/common_button.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController name = TextEditingController();
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
            title: Text('Sign Up'.toUpperCase()),
          ),
          body: Column(
            children: [
              /// name textfield
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

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
                  createAccount(
                          name: name.text,
                          email: email.text,
                          password: password.text)
                      .then(
                    (value) {
                      if(value!=null){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                                (route) => false);
                      }
                    },
                  );
                },
                buttonTxt: 'Create Account'.toUpperCase(),
              ),

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                  child: Text('Login'.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
