import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_check_snipe_v1/widgets/rounded_button.dart';

import '../../models/movies.dart';
import '../../models/user.dart';

class SearchedMovieDetailDialog extends StatelessWidget {
  const SearchedMovieDetailDialog({
    Key? key,
    required this.movie,
    required CollectionReference<Map<String, dynamic>> movieCollectionReference,
  })  : _movieCollectionReference = movieCollectionReference,
        super(key: key);

  final Movie movie;
  final CollectionReference<Map<String, dynamic>> _movieCollectionReference;

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
                backgroundImage: NetworkImage(movie.photoUrl as String),
                radius: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(movie.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Category: ${movie.type}')),
            Text('Published: ${movie.year}'),
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
                    _movieCollectionReference.add(Movie(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      title: movie.title,
                      type: movie.type,
                      photoUrl: movie.photoUrl,
                      year: movie.year,
                    ).toMap());
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(username)
                        .collection('usermovies')
                        .doc(movie.title)
                        .set({
                      "movieTitle": movie.title,
                      "photoUrl": (movie.photoUrl == null ||
                              movie.photoUrl!.isEmpty ||
                              movie.photoUrl == 'N/A')
                          ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
                          : movie.photoUrl,
                      "type": movie.type == null ? "N/A" : movie.type,
                      "year": movie.year == null ? "N/A" : movie.year
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
