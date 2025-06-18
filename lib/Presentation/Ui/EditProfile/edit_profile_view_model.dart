import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Core/Base/base_view_model.dart';
import 'edit_profile_navigator.dart';

class EditProfileViewModel extends BaseViewModel<EditProfileNavigator> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  List<String> genders = ["Select Gender", "Male", "Female"];
  String selectedGender = "Select Gender";

  DateTime birthDate = DateTime.now();
  late String selectedDate;

  EditProfileViewModel();

  String? errorMessage;

  String? nameValidation(String name) {
    if (name.isEmpty) {
      return local!.nameCantBeEmpty;
    } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(name)) {
      return local!.invalidName;
    }
    return null;
  }

  String? phoneValidation(String value) {
    if (value.isEmpty) {
      return local!.enterPhoneNumber;
    } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
      return local!.enterValidMobileNumber;
    }
    return null;
  }

  void changeDate(DateTime? dateTime) {
    if (dateTime != null) {
      birthDate = dateTime;
      selectedDate = DateFormat("yMMMMd").format(dateTime);
      notifyListeners();
    }
  }

  void changeSelectedGender(String gender) {
    if (gender != "Select Gender") {
      selectedGender = gender;
      notifyListeners();
    }
  }

  void showDatePicker() {
    navigator!.showCustomDatePicker();
  }

  Future<void> updateUserData() async {
    if (selectedDate == local!.birthDate) {
      navigator!.showFailMessage(
        message: local!.birthDate,
        posActionTitle: local!.ok,
        posAction: showDatePicker,
      );
      return;
    }

    if (selectedGender == "Select Gender") {
      navigator!.showFailMessage(
        message: local!.selectYourGender,
        posActionTitle: local!.ok,
      );
      return;
    }
  }
}
