import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

var auth = FirebaseAuth.instance;

Future<bool> signInWithGoogle() async {
  bool signedIn = false;
  try {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await auth.signInWithCredential(credential);
    signedIn = true;

  } catch (e) {
    print(e);
    return signedIn;
  }
  return signedIn;
}

Future signOut() async {
  List<Future> signOutOperations = [];
  Future authSignOut = auth.signOut();
  Future googleSignOut = GoogleSignIn().signOut();
  signOutOperations.add(authSignOut);
  signOutOperations.add(googleSignOut);
  return await Future.wait(signOutOperations);
}
