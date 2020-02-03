import 'package:flutter/material.dart';
import 'package:gfk_questionnaire/screens/section_menu.dart';
import 'package:gfk_questionnaire/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GFK Questionnaire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Giftschein Fragen"),
          actions: [
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {

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

            return SectionMenu(snapshot.data);
          },
        ),
      ),
    );
  }
}
