import 'dart:math';

class SprixGame {
  final int wordLength;

  SprixGame(this.wordLength);

  final List<dynamic> allWords = [];

  String word = "";
  String scrambledWord = "";

  void init(List<dynamic> allWords) {
    this.allWords.clear();
    this.allWords.addAll(allWords);
  }

  void clear() {
    word = "";
    scrambledWord = "";
  }

  String randomScramble() {
    if (word == "") {
      final List<dynamic> subList =
          allWords.where((element) => element.length == wordLength).toList();

      // generates a new Random object
      final random = Random();

      // generate a random index based on the list length
      // and use it to retrieve the element
      word = subList[random.nextInt(subList.length)].toUpperCase();
      scrambledWord = String.fromCharCodes(word.runes.toList()..shuffle());
    }

    return scrambledWord;
  }
}

class Letter {
  String? letter;
  int code = 0;

  Letter(this.letter, this.code);
}
