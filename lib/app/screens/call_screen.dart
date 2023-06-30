import 'package:chat_app/app/zego_call.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String roomId;

  CallScreen({required this.userId, required this.userName,required this.roomId});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      key: ZegoCallServices.zegoNavigatorKey,
      appID: 867192200,
      // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          'ef0ba35aaae21a68351e7ad4a02e2811435c3485ac83d6edaca08dd1bec5a91e',
      // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userId,
      userName: userName,
      callID: roomId.replaceAll(' ',''),
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}
