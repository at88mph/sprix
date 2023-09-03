import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprix/util/sprix.dart';
import 'package:http/http.dart' as http;
import 'package:sprix/auth/secrets.dart';

class SprixView extends StatefulWidget {
  const SprixView({Key? key}) : super(key: key);

  @override
  State<SprixView> createState() => _SprixState();
}

class _SprixState extends State<SprixView> {
  final SprixGame sprixGame = SprixGame(7);
  final TextEditingController wordInputController = TextEditingController();
  String wordDefinition = "";

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        side: const BorderSide(color: Colors.white, width: 1.0),
        textStyle: const TextStyle(fontSize: 35.0));
    return FutureBuilder<List<dynamic>>(
        future: DefaultAssetBundle.of(context).loadStructuredData(
            "assets/words-en.json", (String jsonString) async {
          return json.decode(jsonString);
        }),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            sprixGame.init(snapshot.requireData);
            final Text nextWordText = Text(sprixGame.randomScramble(),
                style: const TextStyle(color: Colors.white, fontSize: 74.0));
            return Scaffold(
                backgroundColor: const Color.fromARGB(176, 63, 74, 197),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 104.0),
                      const Text(
                        "Sprix!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Center(child: nextWordText),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        onChanged: (value) {
                          if (value == sprixGame.word) {
                            fetchDefinition(sprixGame).then(
                                (http.Response response) {
                              dynamic jsonData = json.decode(response.body);

                              if (jsonData is List<dynamic> &&
                                  jsonData.isNotEmpty) {
                                setState(() {
                                  wordDefinition = jsonData[0]["shortdef"][0];
                                });
                              } else {
                                setState(() {
                                  wordDefinition = "No definition available.";
                                });
                              }
                            }, onError: (e) {
                              throw e;
                            }).catchError((e) {
                              throw e;
                            });
                          }
                        },
                        controller: wordInputController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        inputFormatters: [UpperCaseTextFormatter()],
                        textAlign: TextAlign.center,
                        maxLength: sprixGame.wordLength,
                        style: const TextStyle(
                            fontSize: 42.0, color: Colors.white),
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: buttonStyle,
                                onPressed: () {
                                  setState(() {
                                    wordInputController.text = sprixGame.word;
                                    fetchDefinition(sprixGame).then(
                                        (http.Response response) {
                                      dynamic jsonData =
                                          json.decode(response.body);

                                      if (jsonData is List<dynamic> &&
                                          jsonData.isNotEmpty) {
                                        setState(() {
                                          wordDefinition =
                                              jsonData[0]["shortdef"][0];
                                        });
                                      } else {
                                        setState(() {
                                          wordDefinition =
                                              "No definition available.";
                                        });
                                      }
                                    }, onError: (e) {
                                      throw e;
                                    }).catchError((e) {
                                      throw e;
                                    });
                                  });
                                },
                                child: const Text("Solve")),
                            ElevatedButton(
                                style: buttonStyle,
                                onPressed: () {
                                  setState(() {
                                    wordInputController.text = "";
                                    wordDefinition = "";
                                    sprixGame.clear();
                                  });
                                },
                                child: const Text("New")),
                          ]),
                      const SizedBox(height: 30.0),
                      Container(
                          margin: const EdgeInsets.fromLTRB(50, 30, 40, 10),
                          child: Text(wordDefinition,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18.0,
                                  color: Colors.yellowAccent))),
                    ]));
          } else {
            return const Text("Loading...");
          }
        });
  }
}

Future<http.Response> fetchDefinition(SprixGame game) {
  final String definitionURL =
      "https://dictionaryapi.com/api/v3/references/collegiate/json/${game.word.toLowerCase()}?key=$dictionary_api_key";
  final Uri uri = Uri.parse(definitionURL);
  return http.get(uri);
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
