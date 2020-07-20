import 'dart:math';

import '../locator.dart';
import '../repos/questions_repo.dart';
import '../utils/unique_random.dart';
import 'question.dart';

class NewGame {
  final List<Quest> openQuestions;
  final bool retryFailed;

  Quest currentQuestion;
  List<Quest> completedQuestions = [];
  List<Quest> failedQuestions = []; // When retryFailed == false
  Map<String, int> attempts = {};

  int get totalQuestions =>
      openQuestions.length + completedQuestions.length + failedQuestions.length;

  NewGame(this.openQuestions, {this.retryFailed}) {
    nextQuestion();
  }

  void nextQuestion() {
    if (openQuestions.isNotEmpty) currentQuestion = openQuestions.first;
    // currentAnswer = aRepo.getAnswer(currentQuestion.id);
    // print(currentAnswer.array);
  }

  // FIXME
  bool checkAnswer(List<bool> answer) {
    attempts.update(currentQuestion.id, (value) => value + 1,
        ifAbsent: () => 1);

    // if (listEquals(currentAnswer.array, answer)) {
    //   completedQuestions.add(currentQuestion);
    //   openQuestions.remove(currentQuestion);
    //   return true;
    // } else if (!retryFailed) {
    //   // if we should not retry the question, we need to delete it from the openQuestions
    //   failedQuestions.add(currentQuestion);
    //   openQuestions.remove(currentQuestion);
    //   return false;
    // }

    return false;
  }

  // 20 random Questions from GFK I, II and III
  factory NewGame.exam() {
    final QuestionsRepo qRepo = locator();

    List<Quest> gfk1 = [];
    List<Quest> gfk2 = [];
    List<Quest> gfk3 = [];

    for (var i in List<int>.generate(25, (i) => i)) {
      if (i < 9)
        gfk1.addAll(qRepo.getAll(section: i));
      else if (i < 17)
        gfk2.addAll(qRepo.getAll(section: i));
      else
        gfk3.addAll(qRepo.getAll(section: i));
    }

    var questions = [
      ...Random().uniqueInts(gfk1.length, 20).map((r) => gfk1[r]),
      ...Random().uniqueInts(gfk2.length, 20).map((r) => gfk2[r]),
      ...Random().uniqueInts(gfk3.length, 20).map((r) => gfk3[r]),
    ];

    return NewGame(questions, retryFailed: false);
  }
}
