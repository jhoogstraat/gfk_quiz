import 'dart:convert';

class SectionStats {
  int section;
  var answeredCorrectly = [];
  var answersIncorrectly = [];

  SectionStats(this.section);

  SectionStats.fromJson(Map<String, dynamic> map) {
    section = map["section"];
    answeredCorrectly = map["answeredCorrectly"];
    answersIncorrectly = map["answersIncorrectly"];
  }

  String toJson() {
    return json.encode({
      "section": section,
      "answeredCorrectly": answeredCorrectly,
      "answersIncorrectly": answersIncorrectly,
    });
  }
}
