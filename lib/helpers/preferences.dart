import 'package:family_budget/gen/strings.g.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'keys.dart';

@lazySingleton
class Preferences {
  Preferences(this._prefs);

  final SharedPreferences _prefs;

  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(Keys.accessToken, token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(Keys.refreshToken, token);
  }

  bool checkToken() {
    if (_prefs.containsKey(Keys.accessToken)) {
      final token = _prefs.getString(Keys.accessToken);
      return token != null ? true : false;
    }
    return false;
  }

  Future<void> saveLocale(String locale) async {
    LocaleSettings.setLocaleRaw(locale);
    await _prefs.setString(Keys.locale, locale);
  }

  void getLocale() async {
    final locale = getStringByKey(Keys.locale);
    if (locale != null) {
      LocaleSettings.setLocaleRaw(locale);
    }
  }

  Future<void> deleteAccessToken() async {
    _prefs.remove(Keys.accessToken);
  }

  Future<void> deleteRefreshToken() async {
    _prefs.remove(Keys.refreshToken);
  }

  Future<void> clear() async {
    _prefs.clear();
  }

  Future<void> setStringByKey(String key, String str) async {
    await _prefs.setString(key, str);
  }

  String? getStringByKey(String key) {
    return _prefs.containsKey(key) ? _prefs.getString(key) : null;
  }

  List<String>? getListByKey(String key) {
    return _prefs.containsKey(key) ? _prefs.getStringList(key) : null;
  }

  Future<void> setListByKey(String key, List<String> list) async {
    await _prefs.setStringList(key, list);
  }

  Future<void> setIntByKey(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getIntByKey(String key) {
    return _prefs.containsKey(key) ? _prefs.getInt(key) : null;
  }

  bool getBoolByKey(String key) {
    return _prefs.containsKey(key) ? _prefs.getBool(key)! : true;
  }

  Future<void> setBoolByKey(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<bool> deleteByKey(String key) async {
    return await _prefs.remove(key);
  }

  Future<void> setLocale(String locale) => saveLocale(locale);
}
