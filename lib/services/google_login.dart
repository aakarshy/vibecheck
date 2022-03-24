import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibe_check_snipe_v1/services/create_user.dart';

class GoogleLogin extends GetxController {
  var _googleSignin = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);

  Future<UserCredential> login() async {
    // Trigger the authentication flow
    googleAccount.value = await _googleSignin.signIn();
    final GoogleSignInAccount? googleUser = await _googleSignin.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  logout() async {
    googleAccount.value = await _googleSignin.signOut();
  }
}
