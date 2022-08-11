import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

import '../repository/auth_repository.dart';
import 'form_model.dart';

class AuthHandler {
  StudyJamClient studyJamClient;

  AuthHandler({required this.studyJamClient});

  handleSignInEmail(FormModel model) async {
    AuthRepository authRepository = AuthRepository(studyJamClient);
    var result = await authRepository.signIn(
        login: model.login, password: model.password);
    return result;
  }

  handleGetToken(FormModel model) async {
    final prefs = await SharedPreferences.getInstance();
    // final success = await prefs.remove('token');
    if (prefs.getString('token') == null) {
      TokenDto token = await handleSignInEmail(model);
      await prefs.setString('token', token.toString());
      return token.toString();
    }
    else {
      return prefs.getString('token');
    }
  }
}
