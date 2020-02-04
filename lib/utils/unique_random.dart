import 'dart:math';

extension UniqueRandom on Random {
  // Exclusive max
  List<int> uniqueInts(int max, int count) {
    assert(max > count);
    
    List<int> result = [];

    do {
      var i = this.nextInt(max);
      if (!result.contains(i)) result.add(i);
    } while (result.length < count);

    return result;
  }
}
