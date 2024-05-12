import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  Color color;
  double borderWidth;
  ShapeBorder shape;
  TextStyle textStyle;
  TextEditingController controller;
  String hintText;

  CustomTextField({
    this.color = Colors.blue,
    this.borderWidth = 1.0,
    required this.shape,
    required this.textStyle,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: color,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: borderWidth,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      ),
      style: textStyle,
    );
  }
}
