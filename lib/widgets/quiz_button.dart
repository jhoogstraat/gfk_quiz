import 'package:flutter/material.dart';

class QuizButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const QuizButton({this.title, this.backgroundColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      child: Text(title),
      padding: const EdgeInsets.symmetric(horizontal: 35),
      color: backgroundColor ?? Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: onPressed,
    );
  }
}
