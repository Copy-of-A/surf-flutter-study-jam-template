import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/topics/screens/topics_screen.dart';
import 'package:surf_study_jam/surf_study_jam.dart';
import '../../auth/repository/auth_repository.dart';
import '../../chat/screens/chat_screen.dart';
import '../models/chat_topic_send_dto.dart';
import '../repository/chart_topics_repository.dart';

/// Screen, that is used for creating new chat topics.
class CreateTopicScreen extends StatefulWidget {
  /// Constructor for [CreateTopicScreen].
  const CreateTopicScreen(
      {Key? key,
      required this.chatTopicsRepository,
      required this.studyJamClient, required this.authRepository})
      : super(key: key);
  final IChatTopicsRepository chatTopicsRepository;
  final StudyJamClient studyJamClient;
  final IAuthRepository authRepository;

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _topicDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "flutter tutorial",
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Create new topic"),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _topicNameController,
                    decoration: InputDecoration(
                        hintText: 'Enter topic name',
                        labelText: 'Topic Name',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _topicDescriptionController,
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Enter description',
                        labelText: 'Description',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Builder(
                      builder: (BuildContext context) => ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submit(context);
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _submit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );

    ChatTopicSendDto chatTopicSendDto = ChatTopicSendDto(
        name: _topicNameController.text,
        description: _topicDescriptionController.text);

    _createTopic(chatTopicSendDto).then((token) {
      openChat((context));
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Row(children: [
          const Icon(Icons.report_problem, color: Colors.red),
          const SizedBox(
            width: 10,
          ),
          Text(e.message),
        ])),
      );
    });
  }

  void openChat(BuildContext context) {
    Navigator.push<TopicsScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return TopicsScreen(
              chatTopicsRepository:
                  ChatTopicsRepository(widget.studyJamClient), authRepository: widget.authRepository,);
        },
      ),
    );
  }

  _createTopic(ChatTopicSendDto chatTopicSendDto) async {
    await widget.chatTopicsRepository.createTopic(chatTopicSendDto);
  }
}
