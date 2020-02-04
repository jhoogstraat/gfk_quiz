import 'package:flutter/material.dart';

import 'models/new_game.dart';
import 'screens/exam_screen.dart';
import 'screens/section_menu.dart';
import 'services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Services services;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GFK Questionnaire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Giftschein Quiz"),
            actions: [
              IconButton(
                icon: Icon(Icons.school),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ExamScreen(NewGame.exam(services))),
                  );
                },
              )
            ],
          ),
          body: FutureBuilder<Services>(
            future: Services.loadDefault(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }

              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              services = snapshot.data;

              return SectionMenu(services);
            },
          ),
        ),
      ),
    );
  }
}
