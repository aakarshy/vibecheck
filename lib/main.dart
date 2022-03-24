import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_check_snipe_v1/screens/get_started.dart';
import 'package:vibe_check_snipe_v1/screens/login.dart';
import 'package:vibe_check_snipe_v1/screens/new_account_login_again.dart';
import 'package:vibe_check_snipe_v1/screens/profile.dart';
import 'package:vibe_check_snipe_v1/screens/stuff/games_view.dart';
import 'package:vibe_check_snipe_v1/screens/stuff/movies_view.dart';
import 'package:vibe_check_snipe_v1/screens/stuff/music_view.dart';
import 'package:vibe_check_snipe_v1/screens/view_stuff.dart';

import 'firebase_options.dart';
import 'screens/stuff/books_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
          initialData: null,
          create: (context) => FirebaseAuth.instance.authStateChanges(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(primarySwatch: Colors.blue, hintColor: Colors.amber),
          initialRoute: '/',
          routes: {
            '/': (context) => GetStarted(),
            '/login': (context) => Login(),
            '/profile': (context) => Profile(),
            '/newaccount': (context) => NewAccountLoginAgain(),
            '/viewstuff': (context) => ViewStuff(),
            '/books': (context) => Books(),
            '/movies': (context) => Movies(),
            '/music': (context) => Music(),
            '/games': (context) => Games(),
          }),
    );
  }
}
