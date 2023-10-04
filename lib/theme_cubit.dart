import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/shared_prefs_helper.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit(bool initialState) : super(initialState);

  void toggleTheme() {
    SharedPreferencesHelper.instance.setBool("isDarkTheme", !state);
    emit(!state);
  }
}
