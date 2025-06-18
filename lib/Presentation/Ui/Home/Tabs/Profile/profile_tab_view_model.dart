import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:skinally_aii/Presentation/Ui/Home/Tabs/Profile/profile_tab_navigator.dart';
import '../../../../../Core/Base/base_view_model.dart';
import '../../../../../Core/Utils/shared_preferences_utils.dart';
import '../../../../Models/button.dart';

class ProfileTabViewModel extends BaseViewModel<ProfileTabNavigator> {
  ProfileTabViewModel() {
    loadUserData();
  }


  late List<Button> buttonsData;

  String _userName = '';
  String _userEmail = '';
  bool _isLoading = true;

  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isLoading => _isLoading;

  Future<void> loadUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Try to get user name and email directly
      _userName = await SharedPreferencesUtils.getUserName() ?? '';
      _userEmail = await SharedPreferencesUtils.getUserEmail() ?? '';

      // If direct access didn't work, try to get from full user data
      if (_userName.isEmpty || _userEmail.isEmpty) {
        final userDataString = await SharedPreferencesUtils.getUserData();
        if (userDataString != null && userDataString.isNotEmpty) {
          try {
            final userData = json.decode(userDataString);
            if (userData is Map<String, dynamic>) {
              _userName = userData['name'] ?? userData['username'] ?? '';
              _userEmail = userData['email'] ?? '';
            }
          } catch (e) {
            print('Error parsing user data: $e');
          }
        }
      }

      // Set default values if still empty
      if (_userName.isEmpty) {
        _userName = localProvider!.isEn() ? 'User' : 'مستخدم';
      }
      if (_userEmail.isEmpty) {
        _userEmail = 'user@example.com';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
      _userName = localProvider!.isEn() ? 'User' : 'مستخدم';
      _userEmail = 'user@example.com';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserData() async {
    await loadUserData();
  }

  setButtonsData() {
    buttonsData = [
      Button(
        id: 0,
        icon: EvaIcons.info_outline,
        title: local!.aboutUs,
        onClickListener: goToAboutUsScreen,
        color: const Color(0xff34aadc),
      ),
      Button(
        id: 1,
        icon: EvaIcons.question_mark,
        title: local!.faq,
        onClickListener: goToFAQView,
        color: const Color(0xFF1CAC09),
      ),
      Button(
        id: 2,
        icon: EvaIcons.log_out,
        title: local!.signOut,
        onClickListener: onSignOutPress,
        color: const Color(0xFFF73645),
      ),
      Button(
        id: 3,
        icon: EvaIcons.lock,
        title: local!.changePassword,
        onClickListener: goToResetPasswordScreen,
        color: const Color(0xFFF9A541),
      ),
    ];
  }
  void onSignOutPress() {
    navigator!.showQuestionMessage(
      message: local!.areYouSureToExit,
      negativeActionTitle: local!.cancel,
      posActionTitle: local!.ok,
      posAction: signOut,
    );
  }

  Future<void> signOut() async {
    navigator!.showLoading(message: local!.loading);
    try {
      await SharedPreferencesUtils.clear();
      navigator!.goBack();
      navigator!.goToLoginScreen();
    } catch (e) {
      navigator!.goBack();
      navigator!.showFailMessage(
        message: 'Sign out failed',
        posActionTitle: local!.tryAgain,
      );
    }
  }


  void goToEditProfileScreen() {
    navigator!.goToEditProfileScreen();
  }
  void goToHistoryScreen() {
    navigator!.goToHistoryScreen();
  }
  void goToAboutUsScreen() {
    navigator!.goToAboutUsScreen();
  }
  void goToResetPasswordScreen() {
    navigator!.goToResetPasswordScreen();
  }
  void goToFAQView() {
    navigator!.goToFAQView();
  }
  void goToLoginScreen(){
    navigator!.goToLoginScreen();
  }
}