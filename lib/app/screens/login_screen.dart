import 'package:chat_app/app/screens/home_screen.dart';
import 'package:chat_app/app/screens/sign_up_screen.dart';
import 'package:chat_app/app/services/firebase_methods.dart';
import 'package:chat_app/app/services/social_media_services.dart';
import 'package:chat_app/app/utils/image_const.dart';
import 'package:chat_app/app/widgets/common_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
              SvgPicture.asset(loginPageImg, height: 500),
              // /// email textfield
              // Padding(
              //   padding: const EdgeInsets.all(18.0),
              //   child: TextField(
              //       controller: email,
              //       decoration: InputDecoration(
              //         prefixIcon: Icon(Icons.email),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //       )),
              // ),
              //
              // /// password textfield
              // Padding(
              //   padding: const EdgeInsets.all(18.0),
              //   child: TextField(
              //       controller: password,
              //       decoration: InputDecoration(
              //         prefixIcon: Icon(Icons.lock),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //       )),
              // ),

              // commonButton(
              //   onPress: () {
              //     login(email: email.text, password: password.text).then(
              //       (value) {
              //         if (value != null) {
              //           setState(() {
              //             print('values ::: ${value.email}');
              //           });
              //           ;
              //           Navigator.pushAndRemoveUntil(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => HomeScreen(),
              //             ),
              //             (route) => false,
              //           );
              //         }
              //       },
              //     );
              //   },
              //   buttonTxt: 'Login'.toUpperCase(),
              // ),
              //
              // Padding(
              //   padding: const EdgeInsets.all(18.0),
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => SignUpScreen(),
              //           ));
              //     },
              //     child: Text('Create Account'.toUpperCase()),
              //   ),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await SocialMediaServices().googleSignIn().then(
                        (GoogleSignIn? gmailData) async {
                          if (gmailData != null) {
                            bool isExist = false;
                            await firestore
                                .collection('users')
                                .where('email',
                                    isEqualTo: gmailData.currentUser?.email ??
                                        'user@gmail.com')
                                .get()
                                .then((value) {
                              value.size > 0 ? isExist = true : isExist = false;
                            });
                            if (isExist == true) {
                              login(
                                      email: gmailData.currentUser?.email ??
                                          'user@gmail.com',
                                      password: gmailData.currentUser?.email ??
                                          'user@gmail.com')
                                  .then(
                                (value) {
                                  if (value != null) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                        (route) => false);
                                  }
                                },
                              );
                            } else {
                              createAccount(
                                      name:
                                          gmailData.currentUser?.displayName ??
                                              'user',
                                      email: gmailData.currentUser?.email ??
                                          'user@gmail.com',
                                      password: gmailData.currentUser?.email ??
                                          'user@gmail.com',
                                      profileUrl:
                                          gmailData.currentUser?.photoUrl ?? '')
                                  .then(
                                (value) {
                                  if (value != null) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                        (route) => false);
                                  }
                                },
                              );
                            }
                          }
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(googleIcon),
                              height: 40,
                              width: 40),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Continue with Google',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
