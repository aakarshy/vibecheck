import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/home_screen_style.dart';
import 'login.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            color: HexColor('#5d5fef'),
            child: Column(children: [
              HomeScreenStyle(),
              Expanded(
                  flex: 13,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: HexColor('#80e575c6')),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                                "Engage with people & \nstuff that pass your\n vibe check",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'RalewayLight',
                                    fontWeight: FontWeight.w100,
                                    letterSpacing: 3.0,
                                    fontSize:
                                        MediaQuery.of(context).size.width < 500
                                            ? 26
                                            : 32)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: TextButton.icon(
                                style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: HexColor('#E85FDA'),
                                    textStyle: TextStyle(fontSize: 18)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => (Login())));
                                },
                                icon: Icon(Icons.login_rounded),
                                label: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('Get Started'),
                                )),
                          )
                        ],
                      ))) //Transparency control: https://stackoverflow.com/questions/50081213/how-do-i-use-hexadecimal-color-strings-in-flutter
            ])));
  }
}
