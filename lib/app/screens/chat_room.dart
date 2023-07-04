import 'dart:io';

import 'package:chat_app/app/screens/call_screen.dart';
import 'package:chat_app/app/screens/chat/received_message_ui.dart';
import 'package:chat_app/app/screens/chat/send_message_ui.dart';
import 'package:chat_app/app/services/firebase_methods.dart';
import 'package:chat_app/app/services/notification_services.dart';
import 'package:chat_app/app/utils/image_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'video_play_screen.dart';

class ChatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;
  final String userName ;

  ChatRoom({required this.chatRoomId, required this.userMap,required this.userName});

  TextEditingController message = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  File? imageFile;

  getImage() async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((img) {
      if (img != null) {
        imageFile = File(img.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      'sendBy': auth.currentUser?.displayName,
      'message': '',
      "type": "img",
      'time': FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('image').child('$fileName.jpg');

    var uploadImage = await ref.putFile(imageFile!).catchError((error) async {
      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadImage.ref.getDownloadURL();

      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({'message': imageUrl});
    }
  }

  String status = 'Offline';

  onSendMessage() async {
    try {
      if (message.text.trim().isNotEmpty) {
        Map<String, dynamic> messages = {
          'sendBy': auth.currentUser?.displayName,
          'message': message.text.trim(),
          "type": "text",
          'time': FieldValue.serverTimestamp(),
        };
        await firestore
            .collection('chatroom')
            .doc(chatRoomId)
            .collection('chats')
            .add(messages);

        print('status :: $status');
        if (status == 'Offline') {
          print('deviceToken ::${userMap['deviceToken']}');
          // NotificationServices().sendNotification(
          //     userMap['deviceToken'], message.text.trim(), userName);
          sendNotificationUsingFirebase(  userMap['deviceToken'], message.text.trim(), userName);
        } else {
          print('online :: $status');
        }
        message.clear();
      } else {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // backgroundColor: Colors.grey[200],
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: StreamBuilder(
            stream:
                firestore.collection('users').doc(userMap['uid']).snapshots(),
            builder: (context, snapshot) {
              status = snapshot.data?['status'] ?? 'Offline';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(snapshot.data?['name'] ?? ''),
                  Text(
                    snapshot.data?['status'] ?? '',
                    style: TextStyle(
                        color: snapshot.data?['status'] == 'Online'
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12),
                  ),
                ],
              );
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallScreen(
                          userId: (auth.currentUser?.uid ?? '12').toString(),
                          userName: (auth.currentUser?.displayName ?? 'name'),
                          roomId: chatRoomId),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.video_call,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayScreen(),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(liveStreamIcon),
              ),
            )
          ],
          backgroundColor: Colors.black,
        ),
        body: auth.currentUser == null
            ? Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      margin: EdgeInsets.only(top: 10),
                      child: StreamBuilder(
                        stream: firestore
                            .collection('chatroom')
                            .doc(chatRoomId)
                            .collection('chats')
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data != null) {
                            return ListView.builder(
                              reverse: true,
                              padding: EdgeInsets.only(top: 10),
                              itemCount: snapshot.data?.docs.reversed.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> map =
                                    snapshot.data?.docs[index].data()
                                        as Map<String, dynamic>;
                                return messageView(
                                    size: size,
                                    messageId:
                                        snapshot.data?.docs[index].id ?? '',
                                    map: map,
                                    context: context);
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    Container(
                      height: size.width * 0.22,
                      // color: Colors.grey[200],
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 10, top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: message,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    hintText: 'Type message...',
                                    suffixIcon: GestureDetector(
                                        onTap: () => getImage(),
                                        child: Icon(Icons.image)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: onSendMessage,
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget messageView(
      {size,
      required String messageId,
      required Map<String, dynamic> map,
      required BuildContext context}) {
    // print('time :: ${map['time'].toString().split(',').first.split('(').last.split('seconds=').last}');
    return map['type'] == 'text'
        ? GestureDetector(
            onLongPress: () {
              // showDialog(
              //   context: context,
              //   builder: (context) {
              //     return Dialog(
              //       child: PopupMenuButton(
              //         itemBuilder: (context) {
              //           return [
              //             PopupMenuItem(
              //               onTap: () {
              //                 firestore
              //                     .collection('chatroom')
              //                     .doc(chatRoomId)
              //                     .collection('chats')
              //                     .doc(messageId)
              //                     .delete();
              //               },
              //               child: Text('Delete'),
              //             ),
              //           ];
              //         },
              //       ),
              //     );
              //   },
              // );
            },
            child: Container(
              // width: size.width,
              alignment: map['sendBy'] == auth.currentUser?.displayName
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  // color: map['sendBy'] == auth.currentUser?.displayName
                  //     ? Colors.blue[200]
                  //     : Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: map['sendBy'] == auth.currentUser?.displayName
                    ? Row(
                        children: [
                          Expanded(
                            child: SentMessage(message: map['message']),
                          ),
                          SizedBox(
                            width: 20,
                            child: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    height: 18,
                                    onTap: () {
                                      firestore
                                          .collection('chatroom')
                                          .doc(chatRoomId)
                                          .collection('chats')
                                          .doc(messageId)
                                          .delete();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ];
                              },
                            ),
                          )
                        ],
                      )
                    : ReceivedMessage(message: map['message']),
                // Column(
                //   children: [
                //     Text(
                //       map['message'],
                //       style: TextStyle(
                //           color: map['sendBy'] == auth.currentUser?.displayName
                //               ? Colors.black
                //               : Colors.white,
                //           fontSize: 16),
                //     ),
                //   ],
                // ),
              ),
            ),
          )
        : GestureDetector(
            // onLongPress: () {
            //   FirebaseStorage.instance
            //       .ref()
            //       .child('image')
            //       .child('${messageId}.jpg')
            //       .delete();
            //   firestore
            //       .collection('chatroom')
            //       .doc(chatRoomId)
            //       .collection('chats')
            //       .doc(messageId)
            //       .delete();
            // },
            child: Row(
              mainAxisAlignment: map['sendBy'] == auth.currentUser?.displayName
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.4,
                  alignment: map['sendBy'] == auth.currentUser?.displayName
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: map['message'] != ''
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FullScreenImage(imageUrl: map['message']),
                                ));
                          },
                          child: Container(
                            height: size.height * 0.2,
                            width: size.width * 0.4,
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Image.network(
                              map['message'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                ),
                Visibility(
                  visible: map['sendBy'] == auth.currentUser?.displayName,
                  child: SizedBox(
                    width: 20,
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            height: 18,
                            onTap: () {
                              FirebaseStorage.instance
                                  .ref()
                                  .child('image')
                                  .child('${messageId}.jpg')
                                  .delete();
                              firestore
                                  .collection('chatroom')
                                  .doc(chatRoomId)
                                  .collection('chats')
                                  .doc(messageId)
                                  .delete();
                            },
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Image.network(imageUrl)),
    );
  }
}
