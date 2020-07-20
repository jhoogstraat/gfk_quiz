import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../locator.dart';
import '../../models/question.dart';
import '../../repos/questions_repo.dart';
import '../../repos/settings.dart';

// Represents a active quiz (contains state!)
class QuizViewModel extends StatesRebuilder<QuizViewModel> {
  // Instance variables //
  final int section;
  final DateTime startedAt;
  final Settings settings = locator();

  /// List of QuestionIDs that were answered correctly.
  List<String> answeredCorrectly;

  /// Attempt counter for each QuestionID
  Map<String, int> attemptCounter;

  /// Contains the currenct question.
  Quest quest;
  Map<String, bool> selected;
  List<String> displayIndexToOptionKey;
  // General State Properties. Need to be set for every state transition.
  bool isCurrentGuessCorrect;
  bool showResolution;
  bool quizFinished;

  // Initializers //
  QuizViewModel.newGame(this.section) : startedAt = DateTime.now() {
    answeredCorrectly = [];
    attemptCounter = Map.fromIterable(
        locator<QuestionsRepo>().getAll(section: section).map((e) => e.id),
        key: (key) => key,
        value: (_) => 0);
    setRandomQuest(settings.shuffle);
    isCurrentGuessCorrect = false;
    showResolution = false;
    quizFinished = false;
  }

  QuizViewModel.fromJson(Map<String, dynamic> json)
      : section = json["section"],
        startedAt = DateTime.tryParse(json["startedAt"]) {
    answeredCorrectly = json["answeredCorrectly"];
  }

  String toJson() => json.encode({
        "section": section,
        "answeredCorrectly": answeredCorrectly,
        "startedAt": startedAt.toIso8601String()
      });

  void setRandomQuest(bool shuffle) {
    quest = locator<QuestionsRepo>().getRandomNew(answeredCorrectly, section);
    selected = quest.options.map((key, _) => MapEntry(key, false));
    displayIndexToOptionKey = quest.options.keys.toList();
    if (shuffle) displayIndexToOptionKey.shuffle();
    print(displayIndexToOptionKey.map((e) => quest.option(e).correct));
  }

  // State Events (User initiated events that change the state) //
  void nextQuest() {
    if (locator<QuestionsRepo>().getAll(section: section).length ==
        answeredCorrectly.length) {
      quizFinished = true;
      rebuildStates(["quiz_completed"]);
    } else {
      setRandomQuest(settings.shuffle);
      showResolution = false;
      isCurrentGuessCorrect = false;
      rebuildStates(['newQuestion']);
    }
  }

  /// The tag rebuilds only the [CheckboxListTile]s and nothing else.
  void setOption(String key, bool value) {
    if (!showResolution) {
      selected[key] = value;
      rebuildStates(["checkbox"]);
    }
  }

  /// Called by the [QuizButton].
  /// The User requested to evaluate his solution.
  void checkAnswer() {
    /// Check if at least one option is selected by the user.
    if (selected.values.where((e) => e == true).length <= 0) {
      return;
    }

    /// Increment the counter if already present.
    attemptCounter[quest.id]++;

    /// Get the true answer from the [Quest]
    final trueAnswer =
        quest.options.map((key, value) => MapEntry(key, value.correct));

    isCurrentGuessCorrect = mapEquals(selected, trueAnswer);

    if (isCurrentGuessCorrect) {
      answeredCorrectly.add(quest.id);
    }

    showResolution = true;
    rebuildStates(['resolution']);
  }
}
