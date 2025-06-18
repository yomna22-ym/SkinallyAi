import 'package:flutter/material.dart';
import '../../../Core/Base/base_view_model.dart';
import '../../../Core/Utils/shared_preferences_utils.dart';
import 'ai_navigator.dart';

class AiViewModel extends BaseViewModel<AiNavigator> {
  AiViewModel({required this.userName, this.initialDiagnosis});

  final String? initialDiagnosis;
  final String userName;


  final formKey = GlobalKey<FormState>();
  final pageController = PageController();

  TextEditingController ageController = TextEditingController();
  TextEditingController bodyAreaController = TextEditingController();

  int currentStep = 0;
  String selectedGender = '';
  String selectedSkinType = '';
  bool isGenderDropdownOpen = false;
  bool isSkinTypeDropdownOpen = false;

  final List<String> genderOptionKeys = [
    'male',
    'female',
    'other',
    'preferNotToSay',
  ];

  final List<String> skinTypeOptionKeys = [
    'normal',
    'oily',
    'dry',
    'combination',
    'sensitive',
    'acneProne',
    'mature',
  ];

  List<String> get genderOptions =>
      genderOptionKeys.map((key) {
        switch (key) {
          case 'male':
            return local!.male;
          case 'female':
            return local!.female;
          case 'other':
            return local!.other;
          case 'preferNotToSay':
            return local!.preferNotToSay;
          default:
            return key;
        }
      }).toList();

  List<String> get skinTypeOptions =>
      skinTypeOptionKeys.map((key) {
        switch (key) {
          case 'normal':
            return local!.normal;
          case 'oily':
            return local!.oily;
          case 'dry':
            return local!.dry;
          case 'combination':
            return local!.combination;
          case 'sensitive':
            return local!.sensitive;
          case 'acneProne':
            return local!.acneProne;
          case 'mature':
            return local!.mature;
          default:
            return key;
        }
      }).toList();

  void nextStep() {
    if (validateCurrentStep()) {
      if (currentStep < 4) {
        currentStep++;
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        notifyListeners();
      } else {
        startConsultation();
      }
    }
  }

  void startConsultation() async {
    final userName = await SharedPreferencesUtils.getUserDisplayName();

    navigator!.goToChatScreen(
      userName: userName,
      userAge: ageController.text,
      gender: selectedGender,
      skinType: selectedSkinType,
      bodyArea: bodyAreaController.text,
      diagnosis: initialDiagnosis ?? "Unknown",
    );
  }

  bool validateCurrentStep() {
    switch (currentStep) {
      case 0:
        final age = int.tryParse(ageController.text);
        if (age == null || age < 1 || age > 120) {
          navigator!.showFailMessage(
            message: local!.pleaseEnterValidAge,
            posActionTitle: local!.ok,
          );
          return false;
        }
        break;
      case 1:
        if (selectedGender.isEmpty) {
          navigator!.showFailMessage(
            message: local!.pleaseSelectGender,
            posActionTitle: local!.ok,
          );
          return false;
        }
        break;
      case 2:
        if (bodyAreaController.text.trim().isEmpty) {
          navigator!.showFailMessage(
            message: local!.pleaseSpecifyAffectedArea,
            posActionTitle: local!.ok,
          );
          return false;
        }
        break;
      case 3:
        if (selectedSkinType.isEmpty) {
          navigator!.showFailMessage(
            message: local!.pleaseSelectSkinType,
            posActionTitle: local!.ok,
          );
          return false;
        }
        break;
    }
    return true;
  }

  void toggleGenderDropdown() {
    isGenderDropdownOpen = !isGenderDropdownOpen;
    isSkinTypeDropdownOpen = false;
    notifyListeners();
  }

  void toggleSkinTypeDropdown() {
    isSkinTypeDropdownOpen = !isSkinTypeDropdownOpen;
    isGenderDropdownOpen = false;
    notifyListeners();
  }

  void selectGender(String gender) {
    selectedGender = genderOptionKeys[genderOptions.indexOf(gender)];
    isGenderDropdownOpen = false;
    notifyListeners();
  }

  void selectSkinType(String skinType) {
    selectedSkinType = skinTypeOptionKeys[skinTypeOptions.indexOf(skinType)];
    isSkinTypeDropdownOpen = false;
    notifyListeners();
  }

  String getGenderDisplayText() {
    if (selectedGender.isEmpty) return local!.selectGender;
    switch (selectedGender) {
      case 'male':
        return local!.male;
      case 'female':
        return local!.female;
      case 'other':
        return local!.other;
      case 'preferNotToSay':
        return local!.preferNotToSay;
      default:
        return selectedGender;
    }
  }

  String getSkinTypeDisplayText() {
    if (selectedSkinType.isEmpty) return local!.selectSkinType;
    switch (selectedSkinType) {
      case 'normal':
        return local!.normal;
      case 'oily':
        return local!.oily;
      case 'dry':
        return local!.dry;
      case 'combination':
        return local!.combination;
      case 'sensitive':
        return local!.sensitive;
      case 'acneProne':
        return local!.acneProne;
      case 'mature':
        return local!.mature;
      default:
        return selectedSkinType;
    }
  }

  @override
  void dispose() {
    ageController.dispose();
    bodyAreaController.dispose();
    pageController.dispose();
    super.dispose();
  }
}
