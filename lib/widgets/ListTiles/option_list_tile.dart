import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gfk_quiz/screens/quiz_screen/quiz_view_model.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class OptionListTile extends StatelessWidget {
  final String optionKey;
  final Color _backgroundColor;

  OptionListTile(this.optionKey)
      : _backgroundColor = IN.get<QuizViewModel>().showResolution
            ? (IN.get<QuizViewModel>().quest.option(optionKey).correct
                ? Colors.green.shade100
                : Colors.red.shade100)
            : Colors.transparent;

  /// Rebuilds a single CheckboxTile, but in a very filtered way.
  /// The only thing that can actually change during the quiz is wether the checkbox
  /// is enabled or disabled. So the checkbox's title (which does not change during a specific task) is provided by the child parameter,
  /// which uses IN.get to retrieve the viewModel.
  /// the actual [CheckboxListTile] is the rebuild whenever the tag for the current option
  /// is triggered from the viewModel.
  /// Using tags, only the [CheckboxListTile] changes and nothing else.
  @override
  Widget build(BuildContext context) {
    final viewModel = IN.get<QuizViewModel>();
    final question = viewModel.quest.option(optionKey).markdown;

    return Container(
      color: _backgroundColor,
      child: StateBuilder<QuizViewModel>(
        observe: () => IN.get<QuizViewModel>(),
        tag: ['checkbox', 'resolution'],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: MarkdownBody(data: question),
        ),
        builderWithChild: (context, _, title) {
          return Container(
            color: viewModel.showResolution
                ? (viewModel.quest.option(optionKey).correct
                    ? Colors.green.shade100
                    : Colors.red.shade100)
                : Colors.transparent,
            child: CheckboxListTile(
              title: title,
              value: viewModel.selected[optionKey],
              onChanged: (newValue) => viewModel.setOption(optionKey, newValue),
            ),
          );
        },
      ),
    );
  }
}
