import 'package:flutter/material.dart';

import '../widgets/top_bar.dart';
import '../widgets/view_stuff_button.dart';

class ViewStuff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: TopBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ViewStuffButton(
                            buttonText: "Books",
                            press: () {
                              Navigator.pushNamed(context, '/books');
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ViewStuffButton(
                            buttonText: "Movies / TV",
                            press: () {
                              Navigator.pushNamed(context, '/movies');
                            }),
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ViewStuffButton(
                            buttonText: "Music",
                            press: () {
                              Navigator.pushNamed(context, '/music');
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ViewStuffButton(
                            buttonText: "Gaming",
                            press: () {
                              Navigator.pushNamed(context, '/games');
                            }),
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            ViewStuffButton(buttonText: "Sports", press: () {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            ViewStuffButton(buttonText: "Travel", press: () {}),
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ViewStuffButton(
                            buttonText: "Wishlist", press: () {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            ViewStuffButton(buttonText: "People", press: () {}),
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ViewStuffButton(
                            buttonText: "Products", press: () {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            ViewStuffButton(buttonText: "Other", press: () {}),
                      )
                    ]),
              ],
            ),
          ),
        ));
  }
}
