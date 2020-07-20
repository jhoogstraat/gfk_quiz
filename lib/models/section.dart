import 'question.dart';

class Section {
  final String title;
  final String short;
  final List<Quest> quests;

  const Section({this.title, this.short, this.quests});

  factory Section.fromJson(Map<String, dynamic> json) => Section(
      title: json['title'],
      short: json['short'],
      quests: (json['quests'] as List).map((q) => Quest.fromJson(q)).toList());
}
