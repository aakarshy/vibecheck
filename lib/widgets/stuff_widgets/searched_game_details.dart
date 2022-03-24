import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_check_snipe_v1/widgets/rounded_button.dart';

import '../../models/games.dart';
import '../../models/user.dart';

class SearchedGameDetailDialog extends StatelessWidget {
  const SearchedGameDetailDialog({
    Key? key,
    required this.game,
    required CollectionReference<Map<String, dynamic>> gameCollectionReference,
  })  : _gameCollectionReference = gameCollectionReference,
        super(key: key);

  final Game game;
  final CollectionReference<Map<String, dynamic>> _gameCollectionReference;

  @override
  Widget build(BuildContext context) {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    var authUser = Provider.of<User?>(context);
    var username = authUser!.email.toString().split('@')[0];
    return AlertDialog(
        content: Column(
          children: [
            Container(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(game.photoUrl as String),
                radius: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(game.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Summary: ${game.summary}')),
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.blueGrey.shade100, width: 1)),
            ))
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedButton(
                  radius: 30,
                  color: Colors.amber,
                  text: 'Save',
                  press: () {
                    _gameCollectionReference.add(Game(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      title: game.title,
                      summary: game.summary,
                      photoUrl: game.photoUrl,
                    ).toMap());
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(username)
                        .collection('usergames')
                        .doc(game.title)
                        .set({
                      "gameTitle": game.title,
                      "photoUrl": (game.photoUrl == null ||
                              game.photoUrl!.isEmpty ||
                              game.photoUrl == 'N/A')
                          ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
                          : game.photoUrl,
                      "summary": game.summary == null ? "N/A" : game.summary,
                    });
                    Navigator.of(context).pop();
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {},
                child: RoundedButton(
                    radius: 30,
                    color: Colors.amber,
                    text: 'Cancel',
                    press: () {
                      Navigator.of(context).pop();
                    })),
          )
        ]);
  }
}
