import 'package:flutter/material.dart';

import '../locator.dart';
import '../repos/questions_repo.dart';
import 'quiz_screen/quiz_screen.dart';

class SectionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz der BWL"),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings')),
          // IconButton(
          //   icon: Icon(Icons.school),
          //   onPressed: () => Navigator.pushNamed(context, '/exam'),
          // )
        ],
      ),
      body: ListView.separated(
        itemCount: locator<QuestionsRepo>().sections.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
        ),
        itemBuilder: (context, index) {
          var section = locator<QuestionsRepo>().sectionAt(index);
          return ListTile(
            title: Text(section.short + " - " + section.title),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
