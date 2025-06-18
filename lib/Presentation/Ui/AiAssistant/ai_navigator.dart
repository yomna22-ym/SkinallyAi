import '../../../Core/Base/base_navigator.dart';

abstract class AiNavigator extends BaseNavigator {
  void goToChatScreen({
    required String userName,
    required String userAge,
    required String gender,
    required String skinType,
    required String bodyArea,
    required String diagnosis,
  });
  void goBack();
}