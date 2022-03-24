import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:vibe_check_snipe_v1/widgets/rounded_button.dart';
import 'package:vibe_check_snipe_v1/widgets/update_user_profile.dart';

import '../models/user.dart';
import '../services/google_login.dart';
import '../widgets/top_bar.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

    var authUser = Provider.of<User?>(context);

    var username = authUser!.email.toString().split('@')[0];
    // Map<String, dynamic> userData = {};

    // Future<void> func() async {
    //   Map<String, dynamic> Data = {};
    //   await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(username)
    //       .get()
    //       .then((DocumentSnapshot documentSnapshot) {
    //     if (documentSnapshot.exists) {
    //       Data = documentSnapshot.data() as Map<String, dynamic>;
    //       return Data;
    //     } else
    //       return Data;
    //   });
    // }

    // userData = func() as Map<String, dynamic>;
    // print(userData);

    //final controller = Get.put(GoogleLogin());
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: TopBar(),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: userCollection.doc(username).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  while (!snapshot.hasData) {
                    print("Fetching!");
                  }
                  MUser userListStream(data) {
                    return MUser.fromDocument(data);
                  }

                  MUser curUser = userListStream(snapshot.data);

                  return Center(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                curUser.avatarUrl == null
                                    ? "https://i.pravatar.cc/200"
                                    : curUser.avatarUrl as String),
                            radius: 70),
                      ),
                      Text(
                        "#${curUser.code.toString()}",
                        style: TextStyle(
                            color: HexColor('#706e72'),
                            fontFamily: 'Molengo',
                            fontSize: 18),
                      ),
                      UpdateUserProfile(user: curUser),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RoundedButton(
                          text: "Edit My Stuff",
                          press: () {
                            Navigator.pushNamed(context, '/viewstuff');
                          },
                          color: Colors.black,
                          radius: 10,
                          shadowColor: "#503301",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RoundedButton(
                          text: "Tune My Vibe",
                          press: () {},
                          color: Colors.black,
                          radius: 10,
                          shadowColor: "#503301",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RoundedButton(
                          text: "Vibe Check",
                          press: () {},
                          color: HexColor("#F3B209"),
                          radius: 10,
                          textColor: "#ffffff",
                          widthFactor: 0.3,
                        ),
                      ),
                      //Logout Button
                      ActionChip(
                          avatar: Icon(Icons.logout),
                          label: Text('Logout'),
                          onPressed: () {
                            Get.put(GoogleLogin()).logout();
                            Navigator.pushNamed(context, '/login');
                          })
                    ]),
                  );
                }
              }),
        ));
  }
}
