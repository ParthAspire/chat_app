import 'package:chat_app/app/screens/chat/triangle_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SentMessage extends StatelessWidget {
  final String message;
  final Timestamp? date;

  const SentMessage({
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Monstserrat',
                        fontSize: 14),
                  ),
                ),
              ),
              CustomPaint(painter: Triangle(Colors.grey[900]!)),
            ],
          ),
          Visibility(
            visible: date != null,
            child: Text(
              DateFormat('hh:mm a').format((date ?? Timestamp.now()).toDate()),
              // hh:mm a, d MMM - yyyy
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Monstserrat', fontSize: 10),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(right: 6, left: 50, top: 0, bottom: 4),
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
