import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import '../models/question.dart';
import '../models/section.dart';

class QuestionsRepo {
  List<Section> sections;

  QuestionsRepo.fromJson(String src) {
    final List<dynamic> data = json.decode(src);
    sections = data.map((s) => Section.fromJson(s)).toList();
  }

  static Future<QuestionsRepo> fromFile(String path) async {
    return rootBundle
        .loadString(path)
        .then((file) => QuestionsRepo.fromJson(file));
  }

  Section sectionAt(int index) {
    return sections[index];
  }

  List<Quest> getAll({int section}) {
    return sections[section].quests;
  }

  Quest getAtId(String qId, int section) {
    return sections[section].quests.singleWhere((element) => element.id == qId);
  }

  int numberOfQuestions(int index) {
    return sections[index].quests.length;
  }

  Quest getRandom(int sectionIndex) {
    final section = sections[sectionIndex];
    return section.quests[Random().nextInt(section.quests.length - 1)];
  }

  Quest getAt(int sectionIndex, int questionIndex) {
    return sections[sectionIndex].quests[questionIndex];
  }

  Quest getRandomNew(List<String> completedQuestions, int sectionIndex) {
    final section = sections[sectionIndex];
    final sectionLength = section.quests.length;

    if (sectionLength == completedQuestions.length) return null;

    Quest question;

    do {
      question = section.quests[Random().nextInt(sectionLength)];
    } while (completedQuestions.contains(question.id));

    return question;
  }
}
