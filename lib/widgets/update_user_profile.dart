import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/user.dart';
import 'input_decoration.dart';

class UpdateUserProfile extends StatelessWidget {
  UpdateUserProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final MUser user;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _otherlinkTextController =
        TextEditingController(text: user.otherlink);
    final TextEditingController _instahandleTextController =
        TextEditingController(text: user.instahandle);
    return Container(
        child: Form(
            child: SingleChildScrollView(
                child: Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          style: TextStyle(color: Colors.pink[100]),
          controller: _instahandleTextController,
          decoration: inputDecoration(
              label: 'Your instahandle',
              hintText: '',
              iconPassed: FontAwesomeIcons.instagram),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          style: TextStyle(color: Colors.pink[200]),
          controller: _otherlinkTextController,
          decoration: inputDecoration(
              label: 'otherlink',
              hintText: '',
              iconPassed: FontAwesomeIcons.rss),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  final userChangedotherlink =
                      user.otherlink != _otherlinkTextController.text;
                  final userChangedinstahandle =
                      user.instahandle != _instahandleTextController.text;

                  final userNeedUpdate =
                      userChangedinstahandle || userChangedotherlink;
                  if (userNeedUpdate) {
                    print("updating");
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.username)
                        .update({
                      "otherlink": _otherlinkTextController.text,
                      "instahandle": _instahandleTextController.text
                    });
                  }
                },
                child: Text('Update')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Text('Undo')),
            ),
          ],
        ),
      ),
    ]))));
  }
}
