import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_check_snipe_v1/widgets/rounded_button.dart';

import '../../models/artist.dart';
import '../../models/user.dart';

class SearchedArtistDetailDialog extends StatelessWidget {
  const SearchedArtistDetailDialog({
    Key? key,
    required this.artist,
    required CollectionReference<Map<String, dynamic>>
        artistCollectionReference,
  })  : _artistCollectionReference = artistCollectionReference,
        super(key: key);

  final Artist artist;
  final CollectionReference<Map<String, dynamic>> _artistCollectionReference;

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
                backgroundImage: NetworkImage(artist.photoUrl as String),
                radius: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(artist.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Artist URL: ${artist.artistURL}')),
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
                    _artistCollectionReference.add(Artist(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      title: artist.title,
                      artistURL: artist.artistURL,
                      photoUrl: artist.photoUrl,
                    ).toMap());
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(username)
                        .collection('usermusic')
                        .doc(artist.title)
                        .set({
                      "artistTitle": artist.title,
                      "photoUrl": (artist.photoUrl == null ||
                              artist.photoUrl!.isEmpty ||
                              artist.photoUrl == 'N/A')
                          ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
                          : artist.photoUrl,
                      "artistURL":
                          artist.artistURL == null ? "N/A" : artist.artistURL,
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
