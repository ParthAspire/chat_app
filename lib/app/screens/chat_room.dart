import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ChatRoom({required this.chatRoomId, required this.userMap});

  TextEditingController message = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  onSendMessage() async {
    try {
      if (message.text.trim().isNotEmpty) {
        Map<String, dynamic> messages = {
          'sendBy': auth.currentUser?.displayName,
          'message': message.text.trim(),
          'time': FieldValue.serverTimestamp(),
        };
        message.clear();
        await firestore
            .collection('chatroom')
            .doc(chatRoomId)
            .collection('chats')
            .add(messages);
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(userMap['name']),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: StreamBuilder(
                  stream: firestore
                      .collection('chatroom')
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.only(top: 10),
                        itemCount: snapshot.data?.docs.reversed.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data?.docs[index]
                              .data() as Map<String, dynamic>;
                          return messageView(size: size, map: map);
                          // return Text(snapshot.data?.docs[index]['message']);
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
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          child: TextField(
                            controller: message,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: 'Type message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onSendMessage,
                        icon: Icon(Icons.send),
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

  Widget messageView({size, required Map<String, dynamic> map}) {
    return Container(
      // width: size.width,
      alignment: map['sendBy'] == auth.currentUser?.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          map['message'],
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
