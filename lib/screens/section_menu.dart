import 'package:flutter/material.dart';
import 'package:gfk_questionnaire/screens/quiz_screen.dart';
import 'package:gfk_questionnaire/services.dart';

class SectionMenu extends StatelessWidget {
  final Services services;

  SectionMenu(this.services);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: 25,
        separatorBuilder: (_, __) => Divider(
              height: 1,
            ),
        itemBuilder: (context, index) {
          var section = services.questionsRepo.sectionAt(index);
          return ListTile(
            title: Text(section.short + " - " + section.title),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizScreen(services, index))),
          );
        });
  }
}
