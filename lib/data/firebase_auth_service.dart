import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuthService._privateConstructor();

  late final FirebaseAuth _authInstance = FirebaseAuth.instance;
  static FirebaseAuthService? _instance;

  static FirebaseAuthService get authService {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = FirebaseAuthService._privateConstructor();
      return _instance!;
    }
  }

  Future<User?> signInOrCreateWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential result =
          await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = result.user;
      return user;
    } on FirebaseAuthException catch (signInError) {
      print("error: ${signInError.code}");
      if (signInError.code == 'email-already-in-use') {
        try {
          final UserCredential result =
              await _authInstance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final User? user = result.user;
          return user;
        } catch (error) {
          print('Error signing in user: $error');
          return null;
        }
      } else {
        print('Other error: ${signInError.code}');
        return null;
      }
    }
  }

  Future<void> signOut() async {
    await _authInstance.signOut();
  }

  User? getCurrentUser() {
    return _authInstance.currentUser;
  }
}
