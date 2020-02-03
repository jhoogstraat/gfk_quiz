import 'package:gfk_questionnaire/repos/answers_repo.dart';
import 'package:gfk_questionnaire/repos/questions_repo.dart';

class Services {
  final QuestionsRepo questionsRepo;
  final AnswersRepo answersRepo;

  Services(this.questionsRepo, this.answersRepo);

  static Future<Services> loadDefault() async {
    return Services(await QuestionsRepo.loadFile('assets/data/questions.json'),
        await AnswersRepo.loadFile('assets/data/answers.json'));
  }
}
