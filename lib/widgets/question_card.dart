import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../screens/quiz_screen/quiz_view_model.dart';
import 'ListTiles/option_list_tile.dart';

class QuestionCard extends StatelessWidget {
  @override
  build(BuildContext context) {
    final viewModel = IN.get<QuizViewModel>();

    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _questionTitle(viewModel),
            Divider(height: 2, thickness: 2),
            _optionsList(viewModel)
          ],
        ),
      ),
    );
  }

  _questionTitle(QuizViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: MarkdownBody(
        data: viewModel.quest.question,
        imageDirectory: 'assets/images/',
      ),
    );
  }

  _optionsList(QuizViewModel viewModel) {
    return ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          final optionKey = viewModel.displayIndexToOptionKey[index];
          return OptionListTile(optionKey);
        },
        separatorBuilder: (_, __) => Divider(height: 1),
        itemCount: viewModel.quest.options.length);
  }
}
