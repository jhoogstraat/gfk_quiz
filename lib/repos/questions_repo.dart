import 'dart:convert';
import 'dart:math';
import 'package:gfk_questionnaire/models/game.dart';
import 'package:gfk_questionnaire/models/section.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuestionsRepo {
  List<Section> sections;

  QuestionsRepo.fromJson(String src) {
    final List<dynamic> data = json.decode(src);
    sections = data.map((s) => Section.fromJson(s)).toList();
  }

  static Future<QuestionsRepo> loadFile(String path) async {
    return rootBundle
        .loadString(path)
        .then((file) => QuestionsRepo.fromJson(file));
  }

  Section sectionAt(int index) {
    return sections[index];
  }

  int numberOfQuestions(int index) {
    return sections[index].q.length;
  }

  Question getRandom(int sectionIndex) {
    final section = sections[sectionIndex];
    return section.q[Random().nextInt(section.q.length - 1)];
  }

  Question getAt(int sectionIndex, int questionIndex) {
    return sections[sectionIndex].q[questionIndex];
  }

  Question getNewOrIncorrect(Game game, int sectionIndex) {
    var section = sections[sectionIndex];
    var sectionLength = section.q.length;

    if (sectionLength == game.answeredCorrectly.length) return null;

    Question question;

    do {
      question = section.q[Random().nextInt(sectionLength)];
    } while (game.answeredCorrectly.contains(question.id));

    return question;
  }
}
