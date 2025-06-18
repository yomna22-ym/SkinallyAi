import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Core/Base/base_view_model.dart';
import 'Tabs/Categories/categories_view.dart';
import 'Tabs/Home/home_tab_view.dart';
import 'Tabs/Profile/profile_tab_view.dart';
import 'Tabs/Services/services_tab_view.dart';

class HomeViewModel extends BaseViewModel {
  int currentIndex = 0;
  PageController pageController = PageController();
  List<int> selectedIndexes = [];

  List<Widget> tabs = [
    const HomeTabView(),
    const CategoriesView(),
    const ServicesTabView(),
    const ProfileTabView(),
  ];

  void initPageView() {
    pageController.addListener(changeSelectedIndexOnScroll);
  }

  void changeSelectedIndex(int selectedIndex) {
    selectedIndexes.add(currentIndex);
    currentIndex = selectedIndex;
    pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void onScreenPop(bool didPop) {
    if (selectedIndexes.isNotEmpty) {
      currentIndex = selectedIndexes.removeLast();
    } else {
      navigator?.showQuestionMessage(
        message: local!.areYouSureToExit,
        negativeActionTitle: local!.ok,
        negativeAction: () => SystemNavigator.pop(),
        posActionTitle: local!.cancel,
      );
    }
    notifyListeners();
  }

  void changeSelectedIndexOnScroll() {
    selectedIndexes.add(currentIndex);
    currentIndex = pageController.page?.toInt() ?? 0;
    notifyListeners();
  }

  @override
  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }


}
