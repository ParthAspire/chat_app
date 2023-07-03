import 'package:chat_app/app/screens/chat_room.dart';
import 'package:chat_app/app/screens/login_screen.dart';
import 'package:chat_app/app/services/firebase_methods.dart';
import 'package:chat_app/app/utils/image_const.dart';
import 'package:chat_app/app/widgets/common_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../services/social_media_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TextEditingController search = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic>? userMap;

  bool isDataLoading = true;

  List<Map<String, dynamic>> usersList = [];

  @override
  void initState() {
    getAllUsers();
    WidgetsBinding.instance.addObserver(this);

    onUserLogin();

    super.initState();
    setUserStatus('Online');
  }

  /// on App's user login
  void onUserLogin() {
    /// 1.2.1. initialized ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged in or re-logged in
    /// We recommend calling this method as soon as the user logs in to your app.
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 867192200 /*input your AppID*/,
      appSign:
          'ef0ba35aaae21a68351e7ad4a02e2811435c3485ac83d6edaca08dd1bec5a91e' /*input your AppSign*/,
      userID: auth.currentUser?.uid ?? '1',
      userName: auth.currentUser?.displayName ?? 'user',
      plugins: [],
    );
  }

  /// on App's user logout
  void onUserLogout() {
    /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged out
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setUserStatus('Online');
    } else {
      setUserStatus('Offline');
    }
    super.didChangeAppLifecycleState(state);
  }

  //get only last message of a specific chat
  Future<String?> getLastMessage(String roomId) async {
    QueryDocumentSnapshot? lastMessage;
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .orderBy('time', descending: true)
        .limit(1)
        .get()
        .then((value) {
      lastMessage = value.docs.firstOrNull;
      print('last msg ::: ${lastMessage?.get('message')}');
      firestore.collection('users').doc(auth.currentUser?.uid).update({
        'lastMsg': lastMessage?.get('message'),
      });
      firestore
          .collection('users')
          .doc(auth.currentUser?.uid)
          .get()
          .then((value) {
        print('firestore :: ${value.data()}');
      });
      return lastMessage?.get('message');
    });
    return lastMessage?['message'];
  }

  /// return chat room Id
  String getChatRoomId({required String user1, required String user2}) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  // search by emailId
  onSearch() async {
    try {
      await firestore
          .collection('users')
          .where('email', isEqualTo: search.text.trim())
          .get()
          .then((value) {
        setState(() {
          userMap = value.docs[0].data();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  /// get all users from firebase
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final CollectionReference usersCollection = firestore.collection('users');

    QuerySnapshot querySnapshot = await usersCollection.get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      // var lastMsg =
      await getLastMessage(getChatRoomId(
        user1: auth.currentUser?.displayName ?? '',
        user2: document['name'],
      ));
      // print('lastMsg :: ${lastMsg}');
      // usersCollection.doc(auth.currentUser?.uid).update({
      //   'lastMsg': lastMsg,
      // });
      Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
      print('userData :: ${userData}');
      usersList.add(userData);
    }

    setState(() {
      isDataLoading = false;
    });
    return usersList;
  }

  setUserStatus(String status) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome ${auth.currentUser?.displayName ?? ''}'),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              padding: EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8),
              //   border: Border.all(color: Colors.amber),
              // ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Are you sure.! You want to Logout.?',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                commonButton(
                                    onPress: () {
                                      Navigator.pop(context);
                                    },
                                    buttonTxt: 'NO',
                                    width: 58,
                                    height: 30,
                                    textStyle: TextStyle(
                                      color: Colors.red,
                                    ),
                                    bgColor: Colors.white,
                                    borderColor: Colors.red),
                                commonButton(
                                    onPress: () {
                                      SocialMediaServices()
                                          .googleSignInData
                                          .signOut();
                                      firestore
                                          .collection('users')
                                          .doc(auth.currentUser?.uid)
                                          .update({'status': 'Offline'});
                                      logOut().then((value) =>
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(),
                                              ),
                                              (route) => false));
                                    },
                                    buttonTxt: 'YES',
                                    width: 58,
                                    height: 30,
                                    textStyle: TextStyle(
                                      color: Colors.green,
                                    ),
                                    bgColor: Colors.white,
                                    borderColor: Colors.green),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Image.asset(logoutIcon),
              ),
            ),
          ],
        ),
        body: isDataLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: search,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: IconButton(
                            onPressed: () {
                              onSearch();
                            },
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    child: clearButtonAndSearchData(),
                  ),
                  StreamBuilder(
                    stream: firestore.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map = {};
                            map['name'] = snapshot.data?.docs[index]['name'];
                            map['email'] = snapshot.data?.docs[index]['email'];
                            map['status'] =
                                snapshot.data?.docs[index]['status'];
                            map['uid'] = snapshot.data?.docs[index]['uid'];
                            map['lastMsg'] =
                                snapshot.data?.docs[index]['lastMsg'];
                            map['deviceToken'] = snapshot.data?.docs[index]['deviceToken'];
                            print('map :: ${map}');
                            return chatTile(map);
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: usersList.length,
                  //   padding: EdgeInsets.symmetric(vertical: 10),
                  //   itemBuilder: (context, index) {
                  //     Map<String, dynamic> map = {};
                  //     map['name'] = usersList[index]['name'];
                  //     map['email'] = usersList[index]['email'];
                  //     map['status'] = usersList[index]['status'];
                  //     map['uid'] = usersList[index]['uid'];
                  //     return chatTile(map);
                  //   },
                  // ),
                ],
              ),
      ),
    );
  }

  chatTile(Map<String, dynamic> userMap) {
    return Padding(
      padding: userMap['name'] != auth.currentUser?.displayName
          ? EdgeInsets.symmetric(vertical: 6, horizontal: 16)
          : EdgeInsets.zero,
      child: Visibility(
        visible: userMap['name'] != auth.currentUser?.displayName,
        child: ListTile(
          onTap: () {
            String roomId = getChatRoomId(
              user1: auth.currentUser?.displayName ?? '',
              user2: userMap['name'],
            );
            print('userMap :: ${userMap}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChatRoom(chatRoomId: roomId, userMap: userMap),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black),
          ),
          visualDensity: VisualDensity(vertical: 0, horizontal: -4),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          trailing: Icon(Icons.message, color: Colors.black),
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
          title: Text(userMap['name']),
          // subtitle: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(userMap['email']),
          //     // Text(userMap['lastMsg']??''),
          //   ],
          // ),
        ),
      ),
    );
  }

  clearButtonAndSearchData() {
    return Column(
      children: [
        userMap != null
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    userMap = null;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red, width: 1.5),
                  ),
                  child: Text('Clear Search',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w500)),
                ),
              )
            : SizedBox(),
        userMap != null ? chatTile(userMap ?? {}) : SizedBox(height: 0),
      ],
    );
  }
}
