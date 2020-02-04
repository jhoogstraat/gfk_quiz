import 'dart:math';
import 'package:flutter/foundation.dart';

import '../services.dart';
import '../utils/unique_random.dart';
import 'answer.dart';
import 'section.dart';

class NewGame {
  final Services services;
  final List<Question> openQuestions;
  final bool retryFailed;

  Question currentQuestion;
  Answer currentAnswer;
  List<Question> completedQuestions = [];
  List<Question> failedQuestions = []; // When retryFailed == false
  Map<String, int> attempts = {};

  int get totalQuestions => openQuestions.length + completedQuestions.length + failedQuestions.length;

  NewGame(this.services, this.openQuestions, {this.retryFailed}) {
    nextQuestion();
  }

  nextQuestion() {
    if (openQuestions.isNotEmpty) currentQuestion = openQuestions.first;
    currentAnswer = services.answersRepo.getAnswer(currentQuestion.id);
    print(currentAnswer.array);
  }

  bool checkAnswer(List<bool> answer) {
    attempts.update(currentQuestion.id, (value) => value + 1,
        ifAbsent: () => 1);

    if (listEquals(currentAnswer.array, answer)) {
      completedQuestions.add(currentQuestion);
      openQuestions.remove(currentQuestion);
      return true;
    } else if (!retryFailed) {
      // if we should not retry the question, we need to delete it from the openQuestions
      failedQuestions.add(currentQuestion);
      openQuestions.remove(currentQuestion);
      return false;
    }

    return false;
  }

  // 20 random Questions from GFK I, II and III
  factory NewGame.exam(Services services) {
    List<Question> gfk1 = [];
    List<Question> gfk2 = [];
    List<Question> gfk3 = [];

    for (var i in List<int>.generate(25, (i) => i)) {
      if (i < 9)
        gfk1.addAll(services.questionsRepo.getAll(section: i));
      else if (i < 17)
        gfk2.addAll(services.questionsRepo.getAll(section: i));
      else
        gfk3.addAll(services.questionsRepo.getAll(section: i));
    }

    var questions = [
      ...Random().uniqueInts(gfk1.length, 20).map((r) => gfk1[r]),
      ...Random().uniqueInts(gfk2.length, 20).map((r) => gfk2[r]),
      ...Random().uniqueInts(gfk3.length, 20).map((r) => gfk3[r]),
    ];

    return NewGame(services, questions, retryFailed: false);
  }
}
