import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthServices {

  static Future<UserCredential> signInWithGoogle() async {

    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    // 🔥 لازم تعمل initialize
    await googleSignIn.initialize();

    final GoogleSignInAccount googleUser =
    await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth =
    googleUser.authentication;

    final AuthCredential credential =
    GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential);
  }
}
