import 'package:chat_app/app/screens/chat/triangle_ui.dart';
import 'package:flutter/material.dart';

class SentMessage extends StatelessWidget {
  final String message;

  const SentMessage({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(14),
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
