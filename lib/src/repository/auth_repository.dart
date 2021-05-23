import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  Future<User> signInWithGoogle() async {
    // Inicio de sesion con Google.
    final _googleSignInAccount = await _googleSignIn.signIn();

    final authentication = await _googleSignInAccount.authentication;

    // Inicio de sesion con Firebase.
    final credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    UserCredential user = await _auth.signInWithCredential(credential);

    return user.user;
  }

  void signOut() {
    _auth.signOut();
  }

  User get currentUser => _auth.currentUser;
}
