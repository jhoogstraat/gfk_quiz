// Represents a active quiz

import 'dart:convert';

class Game {
  int section;
  String question;
  List<String> answeredCorrectly = [];
  List<String> answersIncorrectly = [];

  var startedAt = DateTime.now();

  Game(this.section);

  Game.fromJson(Map<String, dynamic> map) {
    section = map["section"];
    question = map["question"];
    answeredCorrectly = map["answeredCorrectly"];
    answersIncorrectly = map["answersIncorrectly"];
    startedAt = DateTime.tryParse(map["startedAt"]);
  }

  String toJson() {
    return json.encode({
      "section": section,
      "question": question,
      "answeredCorrectly": answeredCorrectly,
      "answersIncorrectly": answersIncorrectly,
      "startedAt": startedAt.toIso8601String()
    });
  }
}
