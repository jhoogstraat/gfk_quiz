import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gfk_questionnaire/models/answer.dart';
import 'package:gfk_questionnaire/models/game.dart';
import 'package:gfk_questionnaire/models/section.dart';

import '../services.dart';

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

  var selectedOptions = {0: false, 1: false, 2: false, 3: false};

  var showAnswer = false;
  var answeredCorrectly = false;
  var allAnswersCorrect = false;

  @override
  void initState() {
    question = widget.services.questionsRepo.getAt(widget.section, 44);
    // question = widget.services.questionsRepo.getNewOrIncorrect(widget.game, widget.section);
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
        allAnswersCorrect = true;
      }

      // Reset All
      showAnswer = false;
      answeredCorrectly = false;
      selectedOptions.updateAll((_, __) => false);
    });
  }

  _setOptionSelected(int index, bool selected) {
    setState(() {
      selectedOptions[index] = selected;
    });
  }

  _checkAnswer() {
    setState(() {
      showAnswer = true;
      answeredCorrectly =
          listEquals(answer.array, selectedOptions.values.toList());

      if (answeredCorrectly) {
        widget.game.answeredCorrectly.add(question.id);
        widget.game.answersIncorrectly
            .removeWhere((element) => element == question.id);
        print(widget.game.answeredCorrectly.length);
      } else if (!widget.game.answersIncorrectly.contains(question.id)) {
        widget.game.answersIncorrectly.add(question.id);
        print(widget.game.answersIncorrectly.length);
      }
    });

    widget.services.gameRepo.save(widget.game);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.services.questionsRepo.sectionAt(widget.section).short +
                " - " +
                question.id),
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
      body: allAnswersCorrect
          ? Center(
              child: Text(
              "Alle Fragen richtig beantwortet!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ))
          : Column(children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(children: [
                          Text(
                            question.descr.join(" "),
                            style: TextStyle(fontSize: 20),
                          ),
                          if (question.img != null)
                            Image.asset(
                                'assets/images/' + question.img + ".png")
                        ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Container(
                              color: showAnswer
                                  ? (answer.array[index]
                                      ? Colors.green.shade100
                                      : Colors.red.shade100)
                                  : Colors.transparent,
                              child: CheckboxListTile(
                                  title: _optionRow(_optionAtIndex(index)),
                                  value: selectedOptions[index],
                                  onChanged: (newVal) {
                                    if (!showAnswer)
                                      _setOptionSelected(index, newVal);
                                  }),
                            );
                          },
                          separatorBuilder: (_, __) => Divider(
                                height: 1,
                              ),
                          itemCount: 4),
                    ],
                  ),
                ),
              ),
              Divider(height: 2,thickness: 2,),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                width: double.infinity,
                color: Colors.white,
                // width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0)),
                  child: Text(showAnswer
                      ? (answeredCorrectly
                          ? "Alles richtig! Weiter"
                          : "Leider nicht richtig.. Weiter")
                      : "Auflösen"),
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  color: showAnswer
                      ? (answeredCorrectly ? Colors.green : Colors.red)
                      : Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: _revealButtonFnForCurrentState(),
                ),
              ),
            ]),
    );
  }

  Function _revealButtonFnForCurrentState() {
    if (!showAnswer) {
      if (selectedOptions.values.reduce((value, element) => value | element))
        return () => _checkAnswer();
      else
        return null;
    } else
      return () => _nextQuestion();
  }

  Option _optionAtIndex(int index) {
    switch (index) {
      case 0:
        return question.a;
      case 1:
        return question.b;
      case 2:
        return question.c;
      case 3:
        return question.d;
    }
  }

  Widget _optionRow(Option o) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [
        if (o.txt != null) Flexible(child: Text(o.txt)),
        if (o.img != null)
          Flexible(
              child: Image.asset(
            "assets/images/" + o.img + ".png",
            scale: 2,
          )),
      ]),
    );
  }
}
