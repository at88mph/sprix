import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;

class WordScrambleView extends StatefulWidget {
  const WordScrambleView({super.key, required this.title});

  // Title of this View
  final String title;

  @override
  State<WordScrambleView> createState() => _SprixState();
}

class _SprixState extends State<WordScrambleView> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final wordFieldController = TextEditingController();

  List<dynamic> allWords = [];
  int currLength = 8; // Sensible default; allow this to be set later.
  String currWord = "";
  String currScramble = "";

  @override
  void dispose() {
    // Clean up the controller
    wordFieldController.dispose();
    allWords = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder<List<dynamic>>(
        future: DefaultAssetBundle.of(context).loadStructuredData(
            "assets/words-en.json", (String jsonString) async {
          return json.decode(jsonString);
        }),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 108.0,
                      ),
                      Text(
                        randomScramble(snapshot.requireData),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 58.0),
                      ),
                      TextField(
                        controller: wordFieldController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 48.0),
                      ),
                      const SizedBox(height: 36.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              wordFieldController.text = currWord;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Solve",
                                  style: TextStyle(fontSize: 18.0)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currWord = "";
                              currScramble = "";
                              wordFieldController.text = "";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child:
                                  Text("New", style: TextStyle(fontSize: 18.0)),
                            ),
                          ),
                        ),
                      )
                    ]));
          } else {
            return const Text('Loading...');
          }
        });
  }

  String randomScramble(List<dynamic> allWords) {
    if (currWord == "") {
      final List<dynamic> subList =
          allWords.where((element) => element.length == currLength).toList();

      // generates a new Random object
      final random = Random();

      // generate a random index based on the list length
      // and use it to retrieve the element
      currWord = subList[random.nextInt(subList.length)];
      currScramble = String.fromCharCodes(currWord.runes.toList()..shuffle());
    }

    return currScramble;
  }
}
