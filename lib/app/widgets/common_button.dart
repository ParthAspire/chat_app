import 'package:flutter/material.dart';

Widget commonButton({
  required Function onPress,
  required String buttonTxt,
  double width = 250,
  double height = 40,
}) {
  return MaterialButton(
    padding: EdgeInsets.zero,
    onPressed: () {
      onPress();
    },
    child: Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
          border: Border.all(color: Colors.white)),
      child: Text(
        buttonTxt,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  );
}
