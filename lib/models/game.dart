import 'dart:convert';

// Represents a active quiz
class Game {
  final int section;

  List<String> answeredCorrectly = [];
  List<String> answersIncorrectly = [];
  Map<String, int> answerCounter = {};

  var startedAt = DateTime.now();

  Game(this.section);

  Game.fromJson(Map<String, dynamic> map) : section = map["section"] {
    answeredCorrectly = map["answeredCorrectly"];
    answersIncorrectly = map["answersIncorrectly"];
    startedAt = DateTime.tryParse(map["startedAt"]);
  }

  String toJson() {
    return json.encode({
      "section": section,
      "answeredCorrectly": answeredCorrectly,
      "answersIncorrectly": answersIncorrectly,
      "startedAt": startedAt.toIso8601String()
    });
  }
}
