import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vibe_check_snipe_v1/screens/profile.dart';

import '../services/create_user.dart';
import '../services/google_login.dart';
import '../widgets/home_screen_style.dart';
import 'new_account_login_again.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controller = Get.put(GoogleLogin());
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Material(child: Obx(() {
      if (controller.googleAccount.value == null)
        return LoginScreen(context);
      else {
        String doc_id =
            controller.googleAccount.value!.email.toString().split('@')[0];
        FirebaseFirestore.instance
            .collection('users')
            .doc(doc_id)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            // print("Heya!!");
            // setState(() {
            //   flag = true;
            // });
            return Navigator.pushNamed(context, '/profile');
          } else {
            createUser(context);
            // print("Welcome!");
            // setState(() {
            //   flag = false;
            // });
            return Navigator.pushNamed(context, '/newaccount');
          }
        });
        // return flag ? Profile() : NewAccountLoginAgain();
        return Profile();
      }
    }));
  }

  Container LoginScreen(BuildContext context) {
    return Container(
      color: HexColor('#5d5fef'),
      child: Column(children: [
        HomeScreenStyle(),
        Expanded(
            flex: 13,
            child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: HexColor('#40e575c6')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w100,
                              letterSpacing: 3.0,
                              fontSize: MediaQuery.of(context).size.width < 500
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
                            controller.login();
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
                    Center(
                      child: Text("\n\nOther login options \ncoming soon!!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w100,
                              letterSpacing: 3.0,
                              fontSize: MediaQuery.of(context).size.width < 500
                                  ? 16
                                  : 22)),
                    ),
                  ],
                )))
      ]),
    );
  }
}
