import '../../../Core/Base/base_view_model.dart';
import 'faq_navigator.dart';

class FAQViewModel extends BaseViewModel<FAQNavigator> {
  void onEarlyDetectionTap(FAQNavigator navigator) {
    navigator.navigateToEarlyDetection();
  }

  void onSkinAllyAiTap(FAQNavigator navigator) {
    navigator.navigateToAIInfo();
  }

  void onWhoShouldUseTap(FAQNavigator navigator) {
    navigator.navigateToUserInfo();
  }

  void onDoesReplaceDocTap(FAQNavigator navigator) {
    navigator.navigateToComparisonWithDoctor();
  }

  void onPrivacyTap(FAQNavigator navigator) {
    navigator.navigateToPrivacyInfo();
  }
}


