import 'package:flutter/material.dart';

/// Screen, that is used for creating new chat topics.
class CreateTopicScreen extends StatelessWidget {
  /// Constructor for [CreateTopicScreen].
  const CreateTopicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "flutter tutorial",
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Flutter Chat"),
            ),
            body: const Text("topic screen")));
  }
}
