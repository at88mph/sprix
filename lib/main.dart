import 'package:flutter/material.dart';
import 'package:sprix/views/sprix_view.dart';

void main() {
  runApp(const SprixApplication());
}

class SprixApplication extends StatelessWidget {
  const SprixApplication({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sprix',
      home: SprixView(),
    );
  }
}
