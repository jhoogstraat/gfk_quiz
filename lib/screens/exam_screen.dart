import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gfk_questionnaire/widgets/quiz_button.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../models/answer.dart';
import '../models/section.dart';
import '../services.dart';
import '../utils/unique_random.dart';
import '../widgets/question_card.dart';

class NewGame {
  final Services services;
  final List<Question> openQuestions;

  Question currentQuestion;
  Answer currentAnswer;
  List<Question> completedQuestions = []; // per section
  Map<String, int> attempts = {};

  int get totalQuestions => openQuestions.length + completedQuestions.length;

  NewGame(this.services, this.openQuestions) {
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

    return NewGame(services, questions);
  }
}

class ExamScreen extends StatefulWidget {
  final NewGame game;

  const ExamScreen(this.game);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

// AppBar(
//           title: Text(
//               widget.services.questionsRepo.sectionAt(widget.section).short +
//                   (quizFinished
//                       ? " - Fertig!"
//                       : " - Frage " + question.id.split(" ").last)),
//           actions: [
//             IconButton(
//               icon: Text(widget.game.answeredCorrectly.length.toString() +
//                   " / " +
//                   widget.services.questionsRepo
//                       .numberOfQuestions(widget.section)
//                       .toString()),
//               onPressed: () {},
//             )
//           ],
//         ),

class _ExamScreenState extends State<ExamScreen> {
  var selection = [false, false, false, false];
  var answerCorrect;

  bool get quizCompleted => widget.game.openQuestions.isEmpty;

  String _gameStats() {
    return widget.game.completedQuestions.length.toString() +
        " / " +
        widget.game.totalQuestions.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(quizCompleted ? "Fertig!" : widget.game.currentQuestion.id),
          actions: [
            IconButton(
              icon: Text(_gameStats()),
              onPressed: () {},
            )
          ]),
      body: Column(
        children: [
          Expanded(
            child: QuestionCard(
                question: widget.game.currentQuestion,
                answer: widget.game.currentAnswer,
                showAnswer: answerCorrect != null,
                selection: selection,
                onChanged: (option, newState) {
                  setState(() => selection[option] = newState);
                }),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: QuizButton(
                enabled: true,
                answer: answerCorrect,
                onCheckAnswer: () => setState(
                    () => answerCorrect = widget.game.checkAnswer(selection)),
                onNextQuestion: () {
                  widget.game.nextQuestion();
                  setState(() => _reset());
                }),
          )
        ],
      ),
    );
  }

  _reset() {
    answerCorrect = null;
    selection = [false, false, false, false];
  }
}
