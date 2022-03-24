import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'rounded_button.dart';

class ViewStuffButton extends StatelessWidget {
  final String buttonText;
  final Function press;
  const ViewStuffButton(
      {Key? key, required this.buttonText, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: buttonText,
      press: () {
        press();
      },
      color: Colors.black,
      radius: 10,
      shadowColor: "#503301",
      widthFactor: 0.25,
    );
  }
}
