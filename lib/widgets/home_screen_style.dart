import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreenStyle extends StatelessWidget {
  const HomeScreenStyle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Text('S n i p e',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: HexColor('#fafdfe'),
                    fontWeight: FontWeight.w500,
                    fontSize: 72,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(8.0, 8.0),
                        blurRadius: 10.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  )),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text('VibeCheck Tool',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: HexColor('#fafdfe'),
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(8.0, 8.0),
                        blurRadius: 10.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
