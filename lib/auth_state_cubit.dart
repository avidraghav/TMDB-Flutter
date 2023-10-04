import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/data/firebase_auth_service.dart';
import 'package:tmdb_flutter/data/shared_prefs_helper.dart';

class AuthStateCubit extends Cubit<bool> {
  AuthStateCubit(bool initialState) : super(initialState);

  void logoutUser() {
    FirebaseAuthService.authService.signOut();
    SharedPreferencesHelper.instance.setBool("isUserLoggedIn", false);
    emit(false);
  }
}
