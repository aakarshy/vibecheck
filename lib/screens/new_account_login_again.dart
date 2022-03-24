import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/home_screen_style.dart';

class NewAccountLoginAgain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: HexColor('#5d5fef'),
          child: Column(children: [
            HomeScreenStyle(),
            Container(
              child: Text('Welcome My New friend! Login Again:-'),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: TextButton.icon(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: HexColor('#E85FDA'),
                        textStyle: TextStyle(fontSize: 18)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => (Login())));
                    },
                    icon: Icon(Icons.games_rounded),
                    label: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Sign In With Google'),
                    )),
              ),
            ),
          ])),
    );
  }
}
