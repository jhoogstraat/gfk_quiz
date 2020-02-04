class Section {
  String title;
  String short;
  List<Question> q;

  Section.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    short = json['short'];
    if (json['q'] != null) {
      q = new List<Question>();
      json['q'].forEach((v) {
        q.add(new Question.fromJson(v));
      });
    }
  }
}

class Question {
  String id;
  List<String> descr;
  String img;
  Option a;
  Option b;
  Option c;
  Option d;

  List<Option> get array => [a, b, c, d];

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descr = json['descr'].cast<String>();
    img = json['img'];
    a = Option.fromJson(json['a']);
    b = Option.fromJson(json['b']);
    c = Option.fromJson(json['c']);
    d = Option.fromJson(json['d']);
  }
}

class Option {
  String img;
  String txt;

  Option.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    txt = json['txt'];
  }
}
