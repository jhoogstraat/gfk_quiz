import 'package:flutter/material.dart';
import 'package:gfk_questionnaire/models/section.dart';

import '../models/new_game.dart';
import '../widgets/ListTiles/attempt_list_tile.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_button.dart';

class ExamScreen extends StatefulWidget {
  final NewGame game;

  const ExamScreen(this.game);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  var selection = [false, false, false, false];
  var isCorrectAnswer;

  bool quizCompleted = false;
  bool get optionsSelected =>
      selection.firstWhere((s) => s, orElse: () => false);

  String _gameStats() {
    return (widget.game.completedQuestions.length +
                widget.game.failedQuestions.length)
            .toString() +
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
      body: quizCompleted
          ? _resultList()
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                    child: QuestionCard(
                        question: widget.game.currentQuestion,
                        answer: widget.game.currentAnswer,
                        showAnswer: isCorrectAnswer != null,
                        selection: selection,
                        onChanged: (option, newState) {
                          setState(() => selection[option] = newState);
                        }),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: QuizButton(
                      enabled: optionsSelected,
                      correctAnswer: isCorrectAnswer,
                      onCheckAnswer: () {
                        setState(() => isCorrectAnswer =
                            widget.game.checkAnswer(selection));
                      },
                      onNextQuestion: () {
                        widget.game.nextQuestion();
                        setState(() => _reset());
                      }),
                )
              ],
            ),
    );
  }

  Widget _resultList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            "Richtig beantwortet: " +
                widget.game.completedQuestions.length.toString() +
                " (" +
                (widget.game.completedQuestions.length /
                        widget.game.totalQuestions *
                        100)
                    .toStringAsFixed(0) +
                "%)",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 5),
          Text(
            "Falsch beantwortet: " +
                widget.game.failedQuestions.length.toString() +
                " (" +
                (widget.game.failedQuestions.length /
                        widget.game.totalQuestions *
                        100)
                    .toStringAsFixed(0) +
                "%)",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => Container(
                    color: Colors.red.shade100,
                    child: ListTile(
                      title: Text(widget.game.failedQuestions[index].id),
                      onTap: () => _pushQuestionDetail(
                          question: widget.game.failedQuestions[index]),
                    ),
                  ),
              separatorBuilder: (_, __) => Divider(height: 1),
              itemCount: widget.game.failedQuestions.length),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => Container(
                    color: Colors.green.shade100,
                    child: ListTile(
                      title: Text(widget.game.completedQuestions[index].id),
                      onTap: () => _pushQuestionDetail(
                          question: widget.game.completedQuestions[index]),
                    ),
                  ),
              separatorBuilder: (_, __) => Divider(height: 1),
              itemCount: widget.game.completedQuestions.length),
        ],
      ),
    );
  }

  _pushQuestionDetail({Question question}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(question.id)),
          body: QuestionCard(
            question: question,
            answer: widget.game.services.answersRepo.getAnswer(question.id),
            showAnswer: true,
            selection: [false, false, false, false],
            onChanged: (_, __) {},
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  _reset() {
    isCorrectAnswer = null;
    selection = [false, false, false, false];

    if (widget.game.openQuestions.isEmpty) quizCompleted = true;
  }
}
