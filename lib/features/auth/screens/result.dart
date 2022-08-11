import 'package:flutter/material.dart';

import '../models/form_model.dart';

class Result extends StatelessWidget {
  // const Result({Key? key}) : super(key: key);

  FormModel model;

  Result({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: const Text('Successful')),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(model.login, style: const TextStyle(fontSize: 22)),
            Text(model.password, style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    ));
  }
}
