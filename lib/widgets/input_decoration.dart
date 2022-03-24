import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

InputDecoration inputDecoration(
    {required String label, required String hintText, IconData? iconPassed}) {
  return InputDecoration(
      fillColor: Colors.purple[600],
      filled: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: HexColor('#69639F'), width: 2.0)),
      labelText: label,
      icon: iconPassed != null
          ? FaIcon(iconPassed, color: Colors.pink[800])
          : null,
      hintText: hintText);
}
