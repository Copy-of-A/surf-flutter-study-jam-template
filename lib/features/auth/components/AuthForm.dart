import 'package:flutter/material.dart';
import 'package:surf_study_jam/surf_study_jam.dart';
import '../../chat/repository/chat_repository.dart';
import '../../chat/screens/chat_screen.dart';
import '../models/authHandler.dart';
import '../models/form_model.dart';
import '../models/token_dto.dart';
import '../repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  StudyJamClient studyJamClient = StudyJamClient();

  void _auth() {
    ChatRepository chatRepository = ChatRepository(studyJamClient);
    FormModel model = FormModel(
        login: loginController.text.toString(),
        password: passwordController.text.toString());
    AuthHandler authHandler = AuthHandler(
      studyJamClient: studyJamClient,
    );
    authHandler.handleGetToken(model).then((data) {
      print("data from auth: $data");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    chatRepository: chatRepository,
                  )));
    }).catchError((e) => {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Row(children: const [
              Icon(Icons.error),
              SizedBox(width: 15,),
              Text('Invalid login or password'),
            ])),
          )
        });
  }

  void _submit() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );
    _auth();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: loginController,
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
            TextFormField(
              controller: passwordController,
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
              // obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                    // _formKey.currentState.save();
                    _submit();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
