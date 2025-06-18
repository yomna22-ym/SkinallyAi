import '../../../Core/Base/base_navigator.dart';

abstract class RegisterNavigator extends BaseNavigator {
  void goToLoginScreen();
  void goToLoginScreenWithData({required String email, required String password});
  void goToHomeScreen();
}
