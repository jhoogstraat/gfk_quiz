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

  @override
  void initState() {
    question = widget.services.questionsRepo
        .getNewOrIncorrect(widget.game, widget.section);
    answer = widget.services.answersRepo.getAnswer(question.id);

    print(answer.array);

    super.initState();
  }

  _newQuestion() {
    setState(() {
      question = widget.services.questionsRepo
          .getNewOrIncorrect(widget.game, widget.section);
      answer = widget.services.answersRepo.getAnswer(question.id);

      print(answer.array);

      // Reset All
      showAnswer = false;
      answeredCorrectly = false;
      selectedOptions.updateAll((_, __) => false);
    });
  }

  _setSelected(int index, bool selected) {
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

      widget.services.gameRepo.save(widget.game);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.services.questionsRepo.sectionAt(widget.section).short),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Text(
            "GFK " + question.id,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(
            height: 1,
          ),
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
                Image.asset('assets/images/' + question.img + ".png")
            ]),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.separated(
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
                          if (!showAnswer) _setSelected(index, newVal);
                        }),
                  );
                },
                separatorBuilder: (_, __) => Divider(
                      height: 1,
                    ),
                itemCount: 4),
          ),
          RaisedButton(
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
            onPressed: () {
              if (!showAnswer &&
                  selectedOptions.values
                      .reduce((value, element) => value | element)) {
                _checkAnswer();
              } else if (showAnswer) _newQuestion();
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
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
