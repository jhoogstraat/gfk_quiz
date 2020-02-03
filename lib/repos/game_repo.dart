import 'dart:convert';

import 'package:gfk_questionnaire/models/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameRepo {
  SharedPreferences prefs;

  GameRepo(this.prefs);

  Game get activeGame {
    if (prefs.containsKey('activeGame')) {
      var encodedGame = json.decode(prefs.getString('activeGame'));
      return Game.fromJson(encodedGame);
    }

    return null;
  }

  void save(Game activeGame) {
    prefs.setString('activeGame', activeGame.toJson());
  }

  Game startNewGame(int section) {
    var game = Game(section);
    save(game);
    return game;
  }
}
