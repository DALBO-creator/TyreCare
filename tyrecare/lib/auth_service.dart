import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around Firebase Authentication used by the sign-in UI.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<void> signOut() => _auth.signOut();
}
