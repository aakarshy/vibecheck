import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: HexColor('#35332E'),
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text('SNIPE',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: HexColor("#f3b209"), fontFamily: "Monofett")));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
