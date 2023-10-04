import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._privateConstructor();

  // shouldn't be accessible outside the class
  static SharedPreferencesHelper? _helper;
  static SharedPreferences? _prefs;

  static SharedPreferencesHelper get instance {
    if (_helper != null) {
      return _helper!;
    } else {
      _helper = SharedPreferencesHelper._privateConstructor();
      return _helper!;
    }
  }

  static Future<SharedPreferences> _getSharedPreferencesInstance() async {
    if (_prefs != null) {
      return _prefs!;
    } else {
      _prefs = await SharedPreferences.getInstance();
      return _prefs!;
    }
  }

  Future<void> setBool(String key, bool value) async {
    await _getSharedPreferencesInstance()
        .then((prefs) => {prefs.setBool(key, value)});
  }

  Future<bool> getBool(String key) async {
    bool? value;
    await _getSharedPreferencesInstance()
        .then((prefs) => {value = prefs.getBool(key)});
    return value ?? false;
  }
}
