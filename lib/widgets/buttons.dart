import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonComponent extends StatelessWidget {
  String buttonText;
  Color textColor;
  Color buttonColor;
  VoidCallbackAction callback;
  Icon icon;

  ButtonComponent(this.buttonText, this.textColor, this.buttonColor,
      this.callback, this.icon);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ),
    );
  }
}
