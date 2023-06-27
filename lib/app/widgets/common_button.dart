import 'package:flutter/material.dart';

Widget commonButton({
  required Function onPress,
  required String buttonTxt,
  Color bgColor = Colors.black,
  Color borderColor = Colors.white,
  TextStyle textStyle = const TextStyle(fontSize: 20, color: Colors.white),
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
        color: bgColor,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        buttonTxt,
        style: textStyle,
      ),
    ),
  );
}
