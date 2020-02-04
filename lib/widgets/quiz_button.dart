import 'package:flutter/material.dart';

class QuizButton extends StatelessWidget {
  final bool enabled;
  final bool correctAnswer;
  final Function() onCheckAnswer;
  final Function() onNextQuestion;

  bool get showAnswer => correctAnswer != null;

  const QuizButton(
      {this.enabled,
      this.correctAnswer,
      this.onCheckAnswer,
      this.onNextQuestion});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
      child: Text(showAnswer
          ? (correctAnswer
              ? "Alles richtig! Weiter"
              : "Leider nicht richtig.. Weiter")
          : "Auflösen"),
      padding: const EdgeInsets.symmetric(horizontal: 35),
      color: showAnswer
          ? (correctAnswer ? Colors.green : Colors.red)
          : Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: () {
        if (enabled) {
          if (!showAnswer)
            onCheckAnswer();
          else
            onNextQuestion();
        }
      },
    );
  }
}
