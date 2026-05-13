import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      // Start Google Sign-In
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) return null;

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("ERROR: $e");
      throw e; // 👈 ADD THIS
    }
  }
}