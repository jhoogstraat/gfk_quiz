class Answer {
  bool a;
  bool b;
  bool c;
  bool d;

  Answer.fromMap(Map<String, dynamic> map) {
    a = map["correct"]["a"];
    b = map["correct"]["b"];
    c = map["correct"]["c"];
    d= map["correct"]["d"];
  }

  List<bool> get array => [a, b, c, d];
}