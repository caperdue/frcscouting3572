import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
  Sign in with google
 */
var auth = FirebaseAuth.instance;
bool signedIn = auth.currentUser != null ? true : false;
Future<bool> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    return true;
  }
  return false;
}

/*
  Listen to auth state changes
 */
void listenAuthChanges() {
  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      signedIn = false;
    } else {
      signedIn = true;
    }
  });
}

bool userSignedIn() {
  return signedIn;
}
