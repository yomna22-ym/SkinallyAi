import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Base/base_view_model.dart';
import 'intro_navigator.dart';

class IntroViewModel extends BaseViewModel<IntroNavigator> {
  Future<void> onDonePress() async {
    navigator!.showLoading(message: local!.loading);
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("firstTime", false);
      navigator!.goBack();
      navigator!.goToLoginScreen();
    } catch (e) {
      navigator!.goBack();
      navigator!.showFailMessage(message: local!.someThingWentWrong);
    }
  }
}