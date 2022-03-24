import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

Future<void> createUser(context) async {
  final userCollection = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  // print(auth.currentUser);
  String uid = auth.currentUser!.uid;
  String avatarUrl = auth.currentUser!.photoURL as String;
  String displayName = auth.currentUser!.displayName as String;
  String userName = auth.currentUser!.email.toString().split('@')[0];

  QuerySnapshot querySnapshot = await userCollection.get();
  List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  int size = allData.length;

  MUser user = MUser(
    displayName: displayName,
    uid: uid,
    avatarUrl: avatarUrl,
    username: userName,
    code: size + 1000,
  );
  await userCollection.doc(userName).set(user.toMap());
}
