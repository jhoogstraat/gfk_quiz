import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../locator.dart';
import '../../repos/questions_repo.dart';
import '../../widgets/ListTiles/attempt_list_tile.dart';
import '../../widgets/question_card.dart';
import '../../widgets/quiz_button.dart';
import 'quiz_view_model.dart';

class QuizScreen extends StatelessWidget {
  final int section;

  QuizScreen(this.section);

  get game => IN.get<QuizViewModel>();

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [Inject(() => QuizViewModel.newGame(section))],
      builder: (context) => StateBuilder<QuizViewModel>(
        observe: () => IN.get<QuizViewModel>(),
        tag: ['newQuestion', 'quiz_completed'],
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(titleText),
              actions: [
                FlatButton(
                  child: Text(counterText),
                  onPressed: () {},
                ),
              ],
            ),
            body: game.quizFinished ? _resultList(context) : _quizBody(),
          );
        },
      ),
    );
  }

  String get titleText =>
      locator<QuestionsRepo>().sectionAt(section).short +
      (game.quizFinished
          ? " - Fertig!"
          : " - Frage " + game.quest.id.split(" ").last);

  String get counterText =>
      game.answeredCorrectly.length.toString() +
      " / " +
      locator<QuestionsRepo>().numberOfQuestions(game.section).toString();

  Widget _quizBody() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: QuestionCard(),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          width: double.infinity,
          child: StateBuilder(
            observe: () => game,
            tag: ['resolution'],
            builder: (_, __) => game.showResolution
                ? (game.isCurrentGuessCorrect
                    ? validAnswerButton
                    : invalidAnswerButton)
                : pendingAnswerButton,
          ),
        )
      ],
    );
  }

  Widget _resultList(BuildContext context) {
    final attempts = game.attemptCounter.entries.toList();
    attempts.sort((e1, e2) => e2.value.compareTo(e1.value));

    final sumFirstTry = attempts.where((e) => e.value == 1).length;

    final sumFailed = attempts.length - sumFirstTry;

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
                  onTap: (qId) =>
                      print(attempts) //pushAttemptDetail(context, qId),
                  ),
              separatorBuilder: (_, __) => Divider(height: 1),
              itemCount: attempts.length),
        ),
      ],
    );
  }

  final pendingAnswerButton = QuizButton(
    title: "Auflösen",
    onPressed: () => IN.get<QuizViewModel>().checkAnswer(),
  );

  final validAnswerButton = QuizButton(
    title: "Alles richtig! Weiter",
    backgroundColor: Colors.green,
    onPressed: () => IN.get<QuizViewModel>().nextQuest(),
  );

  final invalidAnswerButton = QuizButton(
    title: "Leider nicht richtig.. Weiter",
    backgroundColor: Colors.red,
    onPressed: () => IN.get<QuizViewModel>().nextQuest(),
  );
}
