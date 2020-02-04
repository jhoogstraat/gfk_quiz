import 'package:flutter/material.dart';

class QuizButton extends StatelessWidget {
  final bool enabled;
  final bool answer;
  final Function() onCheckAnswer;
  final Function() onNextQuestion;

  bool get showAnswer => answer != null;

  const QuizButton(
      {this.enabled, this.answer, this.onCheckAnswer, this.onNextQuestion});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
      child: Text(showAnswer
          ? (answer ? "Alles richtig! Weiter" : "Leider nicht richtig.. Weiter")
          : "Auflösen"),
      padding: const EdgeInsets.symmetric(horizontal: 35),
      color: showAnswer
          ? (answer ? Colors.green : Colors.red)
          : Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: () {
        if (!showAnswer && enabled)
          onCheckAnswer();
        else
          onNextQuestion();
      },
    );
  }
}
