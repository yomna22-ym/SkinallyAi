import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skinally_aii/Presentation/Ui/Register/register_navigator.dart';
import '../../../Core/Base/base_view_model.dart';
import '../../../Core/Utils/shared_preferences_utils.dart';
import '../../../Domain/Models/register_request.dart';
import '../../../Domain/Models/login_request.dart'; // إضافة هذا الـ import
import '../../../Domain/UseCases/register_use_case.dart';
import '../../../Domain/UseCases/login_use_case.dart';

class RegisterViewModel extends BaseViewModel<RegisterNavigator> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;

  RegisterViewModel({
    required this.registerUseCase,
    required this.loginUseCase,
  });

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void goToLoginScreen() {
    navigator!.goToLoginScreen();
  }

  void goToHomeScreen() {
    navigator!.goToHomeScreen();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final request = RegisterRequest(
        username: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phoneNumber: phoneController.text.trim(),
        address: addressController.text.trim(),
      );


      final response = await registerUseCase.execute(request);
      print("Register success: ${response.success}");
      print("Register message: ${response.message}");
      print("Register token: ${response.token}");
      print("Register user: ${response.user}");


      if (response.success) {
        if (response.user != null) {
          await SharedPreferencesUtils.saveUserData(
              json.encode(response.user!));

          final rawName = response.user!['name'] ??
              response.user!['username'] ?? '';
          print("👤 Raw extracted name: $rawName");
          await SharedPreferencesUtils.saveUserName(rawName);

          await SharedPreferencesUtils.saveUserEmail(
              response.user!['email'] ?? '');
        }

        navigator!.showSuccessMessage(
            message: local!.accountCreatedSuccessfully);

        await _performAutoLogin();
      } else {
        _setError(response.message ?? local!.registrationFailed);
      }
    } catch (e) {
      _setError(local!.someThingWentWrong);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _performAutoLogin() async {
    try {
      final loginRequest = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final loginResponse = await loginUseCase.execute(loginRequest);

      if (loginResponse.success && loginResponse.token != null) {
        await SharedPreferencesUtils.saveToken(loginResponse.token!);
        if (loginResponse.refreshToken != null) {
          await SharedPreferencesUtils.saveRefreshToken(
              loginResponse.refreshToken!);
        }
        goToHomeScreen();
      } else {
        goToLoginScreen();
      }
    } catch (e) {
      goToLoginScreen();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String? nameValidation(String name) {
    if (name.isEmpty) {
      return local!.nameCantBeEmpty;
    } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(name)) {
      return local!.invalidName;
    } else {
      return null;
    }
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
    } else if (input != passwordController.text) {
      return local!.passwordDoseNotMatch;
    }
    return null;
  }

  String? phoneValidation(String input) {
    if (input.isEmpty) {
      return local!.enterPhoneNumber;
    } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(input)) {
      return local!.enterValidMobileNumber;
    }
    return null;
  }

  String? addressValidation(String input) {
    if (input.isEmpty) {
      return local!.addressCantBeEmpty;
    }
    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
