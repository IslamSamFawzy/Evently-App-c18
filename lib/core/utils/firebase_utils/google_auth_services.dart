import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:evenrly/core/utils/firebase_utils/token_service.dart';

class GoogleAuthServices {

  static Future<UserCredential> signInWithGoogle() async {

    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    // 🔥 لازم تعمل initialize
    await googleSignIn.initialize();

    final GoogleSignInAccount googleUser =
    await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential =
    GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    
    // Get and cache the Firebase ID token
    await TokenService.getIdToken(forceRefresh: true);
    
    return userCredential;
  }
}
