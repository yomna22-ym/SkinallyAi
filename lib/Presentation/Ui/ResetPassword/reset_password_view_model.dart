import 'package:flutter/material.dart';

import '../../../Core/Base/base_view_model.dart';

class ResetPasswordViewModel extends BaseViewModel {
  ResetPasswordViewModel();

  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordConfirmationController =
      TextEditingController();

  String? passwordValidation(String input) {
    if (input.isEmpty) {
      return local!.passwordCantBeEmpty;
    } else if (input.length < 8) {
      return local!.invalidPasswordLength;
    }
    return null;
  }

  String? passwordConfirmationValidation(String input) {
    if (input.isEmpty) {
      return local!.passwordCantBeEmpty;
    } else if (input != newPasswordController.text) {
      return local!.passwordDoseNotMatch;
    }
    return null;
  }
}
