import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final FirebaseAuth _auth;

  AuthRepo(this._auth);

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserCredential> signInEmail(String email, String pass) {
    return _auth.signInWithEmailAndPassword(email: email, password: pass);
  }

  Future<UserCredential> signUpEmail(String email, String pass) {
    return _auth.createUserWithEmailAndPassword(email: email, password: pass);
  }

  String getUserEmail() {
    final user = _auth.currentUser;
    return user?.email ?? '';
  }

  Future<void> signOut() => _auth.signOut();
}
