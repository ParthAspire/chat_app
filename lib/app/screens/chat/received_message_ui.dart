import 'dart:math' as math; // import this

import 'package:chat_app/app/screens/chat/triangle_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceivedMessage extends StatelessWidget {
  final String message;
  final Timestamp date;

  const ReceivedMessage({
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: CustomPaint(
                  painter: Triangle(Colors.grey[300]!),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Monstserrat',
                        fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          Text(
            DateFormat('hh:mm a').format(date.toDate()),
            // hh:mm a, d MMM - yyyy
            style: TextStyle(
                color: Colors.black, fontFamily: 'Monstserrat', fontSize: 10),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(right: 50.0, left: 18, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 30),
          messageTextGroup,
        ],
      ),
    );
  }
}
