import 'package:firebase_auth/firebase_auth.dart';
import 'package:tmdb_flutter/data/firebase_auth_service.dart';

class AuthScreenVM {
  Future<User?> authenticateUser(
      {required String emailAddress, required String password}) async {
    final authService = FirebaseAuthService.authService;
    final user = await authService.signInOrCreateWithEmailAndPassword(
        emailAddress, password);
    return user;
  }
}
