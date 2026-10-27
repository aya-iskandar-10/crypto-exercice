import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;
  static Future<void>? _init;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Returns null if the user closed the sign-in window.
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        return (await _auth.signInWithPopup(GoogleAuthProvider())).user;
      }
      await (_init ??= GoogleSignIn.instance.initialize()); // once per run
      final account = await GoogleSignIn.instance.authenticate();
      final cred = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      return (await _auth.signInWithCredential(cred)).user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user' ||
          e.code == 'cancelled-popup-request') {
        return null;
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb && _init != null) await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}