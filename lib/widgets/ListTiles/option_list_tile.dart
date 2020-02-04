import 'package:flutter/material.dart';

import '../../models/section.dart';

class OptionListTile extends StatelessWidget {
  final Option option;
  final bool selected;
  final bool showAnswer;
  final Color _backgroundColor;
  final Function(bool) onChanged;

  OptionListTile(this.option,
      {this.selected, bool isCorrect, this.showAnswer, this.onChanged})
      : _backgroundColor = showAnswer
            ? (isCorrect ? Colors.green.shade100 : Colors.red.shade100)
            : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _backgroundColor,
      child: CheckboxListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              if (option.txt != null) Flexible(child: Text(option.txt)),
              if (option.img != null)
                Flexible(
                  child: Image.asset("assets/images/" + option.img + ".png",
                      scale: 2),
                ),
            ],
          ),
        ),
        value: selected,
        onChanged: onChanged,
      ),
    );
  }
}
