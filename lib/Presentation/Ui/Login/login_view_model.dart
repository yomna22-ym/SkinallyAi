import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../Core/Base/base_view_model.dart';
import '../../../Core/Utils/shared_preferences_utils.dart';
import '../../../Domain/Models/login_request.dart';
import '../../../Domain/UseCases/login_use_case.dart';
import 'login_navigator.dart';

class LoginViewModel extends BaseViewModel<LoginNavigator> {
  final LoginUseCase loginUseCase;

  LoginViewModel({required this.loginUseCase});

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool googleLogin = false;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void goToRegistrationScreen() {
    navigator!.goToRegistrationScreen();
  }

  void goToHomeScreen() {
    navigator!.goToHomeScreen();
  }

  void goToForgetPasswordScreen() {
    navigator!.goToForgetPasswordScreen();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final response = await loginUseCase.execute(request);
      print("Login success: ${response.success}");
      print("Login message: ${response.message}");
      print("Login token: ${response.token}");
      print("Login user: ${response.user}");

      if (response.success) {
        if (response.token != null) {
          await SharedPreferencesUtils.saveToken(response.token!);
          if (response.refreshToken != null) {
            await SharedPreferencesUtils.saveRefreshToken(response.refreshToken!);
            await SharedPreferencesUtils.saveUserName(response.user!['name'] ?? response.user!['username'] ?? '');
            await SharedPreferencesUtils.saveUserEmail(response.user!['email'] ?? '');
          }
          if (response.user != null) {
            await SharedPreferencesUtils.saveUserData(json.encode(response.user!));
          }
        }
        navigator!.showSuccessMessage(message: local!.loginSuccessful);
        goToHomeScreen();
      } else {
        // Login failed
        _setError(response.message ?? local!.loginFailed);
      }
    } catch (e) {
      _setError(local!.someThingWentWrong );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAutoLogin() async {
    final isLoggedIn = await SharedPreferencesUtils.isLoggedIn();
    if (isLoggedIn) {
      goToHomeScreen();
    }
  }

  Future<void> logout() async {
    await SharedPreferencesUtils.clearAll();
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

  void changeTheme() {
    themeProvider!.changeTheme(
      themeProvider!.isDark() ? ThemeMode.light : ThemeMode.dark,
    );
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
    }
    return null;
  }

  Future<void> sendVerificationMail() async {
    navigator!.goBack();
    try {
      navigator!.showLoading(message: local!.loading);
      navigator!.goBack();
      navigator!.showSuccessMessage(
        message: local!.weSentEmailVerification,
        posActionTitle: local!.ok,
      );
    } catch (e) {
      navigator!.goBack();
      navigator!.showFailMessage(
        message: local!.someThingWentWrong,
        posActionTitle: local!.tryAgain,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}