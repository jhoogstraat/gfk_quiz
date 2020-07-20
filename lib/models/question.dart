class Option {
  final String markdown;
  final bool correct;

  const Option(this.markdown, this.correct);

  Option.fromJson(Map<String, dynamic> json)
      : markdown = json['txt'],
        correct = json['correct'];
}

class Quest {
  final String id;
  final String question;
  final Map<String, Option> options;

  const Quest(this.id, this.question, this.options);

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      json['id'],
      json['question'],
      (json['options'] as List)
          .asMap()
          .map((key, json) => MapEntry("$key", Option.fromJson(json))),
    );
  }

  Option option(String key) {
    assert(options[key] != null, 'Option at key $key does not exist!!');
    return options[key];
  }
}
