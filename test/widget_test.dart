import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import '../lib/utils/unique_random.dart';

void main() {
  test('Random Int Generator', () {

    Map<int, int> counter = {};

    Random()
        .uniqueInts(300, 20)
        .forEach((z) => counter.update(z, (v) => v + 1, ifAbsent: () => 1));

    Random()
        .uniqueInts(300, 20)
        .forEach((z) => counter.update(z, (v) => v + 1, ifAbsent: () => 1));

    Random()
        .uniqueInts(300, 20)
        .forEach((z) => counter.update(z, (v) => v + 1, ifAbsent: () => 1));

    Random()
        .uniqueInts(300, 20)
        .forEach((z) => counter.update(z, (v) => v + 1, ifAbsent: () => 1));

    Random()
        .uniqueInts(300, 20)
        .forEach((z) => counter.update(z, (v) => v + 1, ifAbsent: () => 1));

    Random()
        .uniqueInts(300, 20)
        .forEach((z) => counter.update(z, (v) => v + 1, ifAbsent: () => 1));

    print(counter);
  });
}
