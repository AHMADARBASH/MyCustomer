import 'package:shared_preferences/shared_preferences.dart';

class CachedData {
  static late SharedPreferences _prefrences;
  static Future init() async =>
      _prefrences = await SharedPreferences.getInstance();

  static void saveTheme({required String themeName}) async {
    await _prefrences.setString('Theme', themeName);
  }

  static String? getTheme() {
    return _prefrences.getString('Theme') ?? '';
  }

  static bool containsTheme() {
    return _prefrences.containsKey('Theme');
  }
}
