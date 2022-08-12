import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/auth/screens/auth_screen.dart';
import 'package:surf_study_jam/surf_study_jam.dart';
import '../../auth/repository/auth_repository.dart';
import '../../chat/repository/chat_repository.dart';
import '../../chat/screens/chat_screen.dart';
import '../models/chat_topic_dto.dart';
import '../repository/chart_topics_repository.dart';
import 'create_topic_screen.dart';

/// Screen with different chat topics to go to.
class TopicsScreen extends StatefulWidget {
  final IChatTopicsRepository chatTopicsRepository;
  final IAuthRepository authRepository;

  /// Constructor for [TopicsScreen].
  const TopicsScreen({
    required this.chatTopicsRepository,
    required this.authRepository,
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

  _logout(BuildContext context) async {
    Navigator.pop(context);
    await widget.authRepository.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "flutter tutorial",
        home: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () => _logout(context),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Flutter Chat"),
                  IconButton(
                    onPressed: () => createNewTopic(context),
                    icon: const Icon(Icons.add_box),
                  ),
                ],
              ),
            ),
            body: Column(children: [
              Expanded(
                  child: ListView.separated(
                itemCount: _currentTopics.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (_, index) => ChatTopic(
                  topicData: _currentTopics.elementAt(index),
                  studyJamClient:
                      widget.chatTopicsRepository.getStudyJamClient(),
                ),
              ))
            ])));
  }

  void createNewTopic(BuildContext context) {
    Navigator.push<ChatScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return CreateTopicScreen(
            chatTopicsRepository: widget.chatTopicsRepository,
            studyJamClient: widget.chatTopicsRepository.getStudyJamClient(),
              authRepository: widget.authRepository,
          );
        },
      ),
    );
  }
}

class ChatTopic extends StatelessWidget {
  final ChatTopicDto topicData;
  final StudyJamClient studyJamClient;

  const ChatTopic(
      {Key? key, required this.topicData, required this.studyJamClient})
      : super(key: key);

  void openChat(BuildContext context) {
    Navigator.push<ChatScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChatScreen(
            chatRepository: ChatRepository(studyJamClient, topicData.id),
            topicName: topicData.name ?? "",
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => openChat(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 5,
          ),
          child: Row(
            children: [
              const Icon(Icons.chat),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Text(
                      topicData.name == null
                          ? 'No name topic'
                          : topicData.name!.trim(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      topicData.description == null
                          ? ''
                          : topicData.description!.trim(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
