import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'db.dart';

/*
  Sign in with google
 */
var auth = FirebaseAuth.instance;

signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await auth.signInWithCredential(credential);
    final doc = await user.get();
    if (!doc.exists) {
      createUser(null);
    }
}

/*
  Listen to auth state changes
 */
void listenAuthChanges() {
  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      print('No longer signed in');
    } else {
      print('User signed in');
    }
  });
}
