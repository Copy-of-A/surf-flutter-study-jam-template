import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/features/auth/exceptions/auth_exception.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chart_topics_repository.dart';
import 'package:surf_study_jam/surf_study_jam.dart';
import '../../topics/screens/topics_screen.dart';
import '../models/form_model.dart';

/// Screen for authorization process.
///
/// Contains [IAuthRepository] to do so.
class AuthScreen extends StatefulWidget {
  /// Repository for auth implementation.
  final IAuthRepository authRepository;

  /// Constructor for [AuthScreen].
  const AuthScreen({
    required this.authRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // TODO(task): Implement Auth screen.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "flutter tutorial",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Chat"),
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
                  controller: _loginController,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your login',
                      labelText: 'Логин',
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
                  onSaved: (String? value) {
                    // model.login = value.toString();
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Stack(children: [
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        hintText: 'Enter your password',
                        labelText: 'Password',
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
                    onSaved: (String? value) {
                      // model.password = value.toString();
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    // obscureText: _isHidden,
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                        onPressed: () => setState(() {
                              _isHidden = !_isHidden;
                            }),
                        alignment: Alignment.centerRight,
                        icon: _isHidden
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off)),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Builder(
                    builder: (BuildContext context) => ElevatedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          // Process data.
                          // _formKey.currentState.save();
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
      ),
    );
  }

  _submit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );

    FormModel model = FormModel(
        login: _loginController.text.toString(),
        password: _passwordController.text.toString());

    _auth(model).then((token) {
      _pushToChat(context, token);
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
    }).then((value) => _saveDataToShared(model));
  }

  _saveDataToShared(FormModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', model.login);
  }

  Future _auth(FormModel model) async {
    final token = await widget.authRepository
        .signIn(login: model.login, password: model.password);
    return token;
  }

  void _pushToChat(BuildContext context, TokenDto token) {
    Navigator.push<ChatScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return TopicsScreen(
              chatTopicsRepository: ChatTopicsRepository(
            StudyJamClient().getAuthorizedClient(token.token),
          ));
          // return ChatScreen(
          //   chatRepository: ChatRepository(
          //     StudyJamClient().getAuthorizedClient(token.token),
          //   ),
          // );
        },
      ),
    );
  }
}
