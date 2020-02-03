import 'dart:convert';
import 'package:gfk_questionnaire/models/answer.dart';
import 'package:flutter/services.dart' show rootBundle;

class AnswersRepo {
  Map<String, Answer> answers;

  AnswersRepo.fromJson(String src) {
    final Map<String, dynamic> data = json.decode(src);
    answers = data.map((key, value) => MapEntry(key, Answer.fromMap(value)));
  }

  static Future<AnswersRepo> loadFile(String path) async {
    return rootBundle
        .loadString(path)
        .then((file) => AnswersRepo.fromJson(file));
  }

  Answer getAnswer(String questionId) {
    return answers[questionId];
  }
}
