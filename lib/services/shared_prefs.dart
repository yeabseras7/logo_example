import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<int> getTotalScore() async {
    final sharedPreferences = await _prefs();
    return sharedPreferences.getInt('totalscore') ?? 0;
  }

  static Future<void> setTotalScore(int tscore) async {
    final sharedPreferences = await _prefs();
    await sharedPreferences.setInt('totalscore', tscore);
  }

  static Future<void> clearTotalScore() async {
    final sharedPreferences = await _prefs();
    await sharedPreferences.setInt('totalscore', 0);
  }
}
