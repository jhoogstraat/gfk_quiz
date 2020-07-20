import 'package:flutter/material.dart';

import 'locator.dart';
import 'screens/section_menu.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(Quiz());
}

class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'GFK Questionnaire',
        theme: ThemeData(
            primarySwatch: Colors.amber,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder()
            })),
        onGenerateRoute: _onGenerateRoute,
      );

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Widget route;

    switch (settings.name) {
      case '/':
        route = SectionMenu();
        break;
      case '/exam':
        route = Scaffold(); //ExamScreen(NewGame.exam());
        break;
      case '/settings':
        route = SettingsScreen();
        break;
    }

    assert(route != null, 'Unknown Route encountered');

    return MaterialPageRoute(
      builder: (context) => route,
    );
  }
}
