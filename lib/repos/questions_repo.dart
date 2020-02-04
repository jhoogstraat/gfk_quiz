import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import '../models/game.dart';
import '../models/section.dart';

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

  List<Question> getAll({int section}) {
    return sections[section].q;
  }

  Question getAtId(String qId, int section) {
    return sections[section].q.singleWhere((element) => element.id == qId);
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

  Question getRandomNew(List<String> completedQuestions, int sectionIndex) {
    var section = sections[sectionIndex];
    var sectionLength = section.q.length;

    if (sectionLength == completedQuestions.length) return null;

    Question question;

    do {
      question = section.q[Random().nextInt(sectionLength)];
    } while (completedQuestions.contains(question.id));

    return question;
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
