import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
  Sign in with google
 */
var auth = FirebaseAuth.instance;
bool signedIn = auth.currentUser != null ? true : false;
void signInWithGoogle() async {
  User? user;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
      } else if (e.code == 'invalid-credential') {
        // handle the error here
      }
    } catch (e) {
      // handle the error here
    }
  }
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
