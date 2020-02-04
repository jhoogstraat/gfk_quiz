import 'package:flutter/material.dart';

import '../models/answer.dart';
import '../models/section.dart';
import 'ListTiles/option_list_tile.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final Answer answer;
  final bool showAnswer;
  final List<bool> selection;
  final Function(int, bool) onChanged;

  const QuestionCard(
      {this.question,
      this.answer,
      this.showAnswer,
      this.selection,
      this.onChanged});

  @override
  build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _questionTitle(),
            Divider(height: 2, thickness: 2),
            _optionsList()
          ],
        ),
      ),
    );
  }

  _questionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(children: [
        Text(
          question.descr.join(" "),
          style: TextStyle(fontSize: 20),
        ),
        if (question.img != null)
          Image.asset('assets/images/' + question.img + ".png")
      ]),
    );
  }

  _optionsList() {
    return ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) => OptionListTile(question.array[index],
                selected: selection[index],
                isCorrect: answer.array[index],
                showAnswer: showAnswer, onChanged: (newVal) {
              if (!showAnswer) onChanged(index, newVal);
            }),
        separatorBuilder: (_, __) => Divider(height: 1),
        itemCount: 4);
  }
}
