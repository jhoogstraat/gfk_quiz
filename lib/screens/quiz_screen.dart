import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gfk_questionnaire/widgets/quiz_button.dart';

import '../models/answer.dart';
import '../models/game.dart';
import '../models/section.dart';
import '../services.dart';
import '../widgets/ListTiles/attempt_list_tile.dart';
import '../widgets/question_card.dart';

class QuizScreen extends StatefulWidget {
  final Services services;
  final int section;
  final Game game;

  QuizScreen(this.services, this.section)
      : game = services.gameRepo.startNewGame(section);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Question question;
  Answer answer;

  var selection = [false, false, false, false];
  var answeredCorrectly = null;
  var quizFinished = false;

  @override
  void initState() {
    // question = widget.services.questionsRepo.getAt(widget.section, 44);
    question = widget.services.questionsRepo
        .getNewOrIncorrect(widget.game, widget.section);
    answer = widget.services.answersRepo.getAnswer(question.id);

    print(answer.array);

    super.initState();
  }

  _nextQuestion() {
    setState(() {
      question = widget.services.questionsRepo
          .getNewOrIncorrect(widget.game, widget.section);

      if (question != null) {
        answer = widget.services.answersRepo.getAnswer(question.id);
        print(answer.array);
      } else {
        quizFinished = true;
      }

      _reset();
    });
  }

  _selectionChanged(int index, bool newState) {
    setState(() {
      selection[index] = newState;
    });
  }

  _checkAnswer() {
    answeredCorrectly = listEquals(answer.array, selection);

    widget.game.answerCounter
        .update(question.id, (value) => value + 1, ifAbsent: () => 1);

    if (answeredCorrectly) {
      widget.game.answeredCorrectly.add(question.id);
      widget.game.answersIncorrectly
          .removeWhere((element) => element == question.id);
    } else if (!widget.game.answersIncorrectly.contains(question.id)) {
      widget.game.answersIncorrectly.add(question.id);
    }

    widget.services.gameRepo.save(widget.game);

    setState(() {});
  }

  void _reset() {
    answeredCorrectly = null;
    selection = [false, false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.services.questionsRepo.sectionAt(widget.section).short +
                  (quizFinished
                      ? " - Fertig!"
                      : " - Frage " + question.id.split(" ").last)),
          actions: [
            IconButton(
              icon: Text(widget.game.answeredCorrectly.length.toString() +
                  " / " +
                  widget.services.questionsRepo
                      .numberOfQuestions(widget.section)
                      .toString()),
              onPressed: () {},
            )
          ],
        ),
        body: quizFinished ? _resultList() : _quiz());
  }

  Widget _quiz() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: QuestionCard(
              question: question,
              answer: answer,
              showAnswer: answeredCorrectly != null,
              selection: selection,
              onChanged: (index, newState) =>
                  _selectionChanged(index, newState),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          width: double.infinity,
          child: QuizButton(
            enabled: selection.reduce((value, element) => value | element),
            answer: answeredCorrectly,
            onCheckAnswer: () => _checkAnswer(),
            onNextQuestion: () => _nextQuestion(),
          ),
        )
      ],
    );
  }

  Widget _resultList() {
    var attempts = widget.game.answerCounter.entries.toList();
    attempts.sort((e1, e2) => e2.value.compareTo(e1.value));

    var sumFirstTry = 0;
    attempts
        .where((element) => element.value == 1)
        .forEach((element) => sumFirstTry++);

    var sumFailed = attempts.length - sumFirstTry;

    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          "Sofort richtig beantwortet: " +
              sumFirstTry.toString() +
              " (" +
              (sumFirstTry / attempts.length * 100).toStringAsFixed(0) +
              "%)",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 5),
        Text(
          "Öfter versucht: " +
              sumFailed.toString() +
              " (" +
              (sumFailed / attempts.length * 100).toStringAsFixed(0) +
              "%)",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
              itemBuilder: (_, index) => AttemptListTile(
                    questionId: attempts[index].key,
                    attempts: attempts[index].value,
                    onTap: (qId) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Scaffold(
                                  appBar: AppBar(
                                    title: Text(qId),
                                  ),
                                  body: QuestionCard(
                                    question: widget.services.questionsRepo
                                        .getAtId(qId, widget.section),
                                    answer: widget.services.answersRepo
                                        .getAnswer(qId),
                                    showAnswer: true,
                                    selection: [false, false, false, false],
                                    onChanged: (_, __) {},
                                  ),
                                ),
                            fullscreenDialog: true)),
                  ),
              separatorBuilder: (_, __) => Divider(height: 1),
              itemCount: attempts.length),
        ),
      ],
    );
  }
}
