import 'package:gfk_questionnaire/repos/answers_repo.dart';
import 'package:gfk_questionnaire/repos/game_repo.dart';
import 'package:gfk_questionnaire/repos/questions_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  final GameRepo gameRepo;
  final QuestionsRepo questionsRepo;
  final AnswersRepo answersRepo;

  Services(this.gameRepo, this.questionsRepo, this.answersRepo);

  static Future<Services> loadDefault() async {
    return Services(
        GameRepo(await SharedPreferences.getInstance()),
        await QuestionsRepo.loadFile('assets/data/questions.json'),
        await AnswersRepo.loadFile('assets/data/answers.json'));
  }
}
