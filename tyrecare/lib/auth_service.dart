import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream per ascoltare lo stato dell'autenticazione
  Stream<User?> get user => _auth.authStateChanges();

  // Login con email e password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Registrazione con email e password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
