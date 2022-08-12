import 'package:flutter/material.dart';

import '../models/chat_topic_dto.dart';
import '../repository/chart_topics_repository.dart';

/// Screen with different chat topics to go to.
class TopicsScreen extends StatefulWidget {
  final IChatTopicsRepository chatTopicsRepository;

  /// Constructor for [TopicsScreen].
  const TopicsScreen({
    required this.chatTopicsRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  Iterable<ChatTopicDto> _currentTopics = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTopicsList();
    });
  }

  _getTopicsList() async {
    final topics = await widget.chatTopicsRepository.getTopics(
        topicsStartDate: DateTime.now().subtract(const Duration(days: 1)));
    setState(() {
      _currentTopics = topics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "flutter tutorial",
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Flutter Chat"),
            ),
            body: Column(children: [
              Expanded(child: ListView.builder(
                itemCount: _currentTopics.length,
                itemBuilder: (_, index) => Text("topic"),
              ))
            ])));
  }
}
