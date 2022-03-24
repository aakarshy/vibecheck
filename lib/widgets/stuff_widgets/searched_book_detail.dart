import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_check_snipe_v1/widgets/rounded_button.dart';

import '../../models/books.dart';
import '../../models/user.dart';

class SearchedBookDetailDialog extends StatelessWidget {
  const SearchedBookDetailDialog({
    Key? key,
    required this.book,
    required CollectionReference<Map<String, dynamic>> bookCollectionReference,
  })  : _bookCollectionReference = bookCollectionReference,
        super(key: key);

  final Book book;
  final CollectionReference<Map<String, dynamic>> _bookCollectionReference;

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
                backgroundImage: NetworkImage(book.photoUrl),
                radius: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(book.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Category: ${book.categories}')),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Page Count: ${book.pageCount}')),
            Text('Author: ${book.author}'),
            Text('Published: ${book.publishedDate}'),
            Expanded(
                child: Container(
                    margin: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.blueGrey.shade100, width: 1)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(book.description,
                            style: TextStyle(
                                wordSpacing: 0.9, letterSpacing: 0.7)),
                      ),
                    )))
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
                    _bookCollectionReference.add(Book(
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            title: book.title,
                            author: book.author,
                            photoUrl: book.photoUrl,
                            categories: book.categories,
                            publishedDate: book.publishedDate,
                            description: book.description,
                            pageCount: book.pageCount)
                        .toMap());
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(username)
                        .collection('userbooks')
                        .doc(book.title)
                        .set({
                      "bookTitle": book.title,
                      "photoUrl": (book.photoUrl == null ||
                              book.photoUrl.isEmpty ||
                              book.photoUrl == 'N/A')
                          ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
                          : book.photoUrl,
                      "category":
                          book.categories == null ? "N/A" : book.categories
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
