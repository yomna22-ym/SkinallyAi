import 'package:flutter/material.dart';

import '../../../Core/Base/base_view_model.dart';

class ForgetPasswordViewModel extends BaseViewModel {
  ForgetPasswordViewModel();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  goToLoginScreen() {
    navigator!.goBack();
  }

  String? emailValidation(String input) {
    if (input.isEmpty) {
      return local!.emailCantBeEmpty;
    } else if (!RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
      r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$",
    ).hasMatch(input)) {
      return local!.enterAValidEmail;
    }
    return null;
  }

}
