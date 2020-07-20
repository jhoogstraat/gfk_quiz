import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  SharedPreferences prefs;

  Settings(this.prefs);

  bool get shuffle => prefs.getBool('pref:shuffle') ?? false;
  set shuffle(bool shuffle) => prefs.setBool('pref:shuffle', shuffle ?? false);
}
