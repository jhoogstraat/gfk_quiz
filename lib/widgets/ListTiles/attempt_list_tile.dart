import 'package:flutter/material.dart';

class AttemptListTile extends StatelessWidget {
  final String questionId;
  final int attempts;
  final Function(String) onTap;

  AttemptListTile({this.questionId, this.attempts, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: attempts > 1 ? Colors.red.shade100 : Colors.green.shade100,
      child: ListTile(
        title: Text(questionId),
        subtitle: Text("Versuche: " + attempts.toString()),
        onTap: () => onTap(questionId),
      ),
    );
  }
}
