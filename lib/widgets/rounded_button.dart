import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double radius;
  final Function press;
  final Color color;
  final String shadowColor;
  final String textColor;
  final double widthFactor;

  const RoundedButton(
      {Key? key,
      required this.text,
      this.radius = 30,
      required this.press,
      required this.color,
      this.shadowColor = "#000000",
      this.textColor = "#B6B0B0",
      this.widthFactor = 0.5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (() => press()),
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * widthFactor,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: this.color,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              boxShadow: [
                BoxShadow(
                  color: HexColor(shadowColor),
                  offset: const Offset(
                    3.0,
                    3.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
                BoxShadow(
                  color: HexColor(shadowColor),
                  offset: const Offset(
                    -1.5,
                    -1.5,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                )
              ],
            ),
            child: Text(text, style: TextStyle(color: HexColor(textColor)))));
  }
}
