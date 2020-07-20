import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'repos/questions_repo.dart';
import 'repos/settings.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final futures = await Future.wait([
    SharedPreferences.getInstance(),
    QuestionsRepo.fromFile('assets/data/questions.json'),
  ]);

  locator.registerSingleton(Settings(futures[0]));
  locator.registerSingleton<QuestionsRepo>(futures[1]);
}
