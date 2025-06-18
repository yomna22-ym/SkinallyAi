import 'dart:io';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import '../../../Core/routes_manager/routes.dart';
import 'home_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseState<HomeView, HomeViewModel> {
  @override
  void initState() {
    super.initState();
    viewModel.initPageView();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<HomeViewModel>(
        builder:
            (context, vm, _) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: PageView(controller: vm.pageController, children: vm.tabs),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: vm.currentIndex,
                items: [
                  BottomNavigationBarItem(
                    label: vm.local!.home,
                    icon: Icon(EvaIcons.home_outline, size: 24.w),
                    activeIcon: Icon(EvaIcons.home, size: 24.w),
                  ),
                  BottomNavigationBarItem(
                    label: vm.local!.categories,
                    icon: Icon(EvaIcons.grid_outline, size: 24.w),
                    activeIcon: Icon(EvaIcons.grid, size: 24.w),
                  ),
                  BottomNavigationBarItem(
                    label: vm.local!.services,
                    icon: Icon(EvaIcons.briefcase_outline, size: 24.w),
                    activeIcon: Icon(EvaIcons.briefcase, size: 24.w),
                  ),
                  BottomNavigationBarItem(
                    label: vm.local!.profile,
                    icon: Icon(EvaIcons.person_outline, size: 24.w),
                    activeIcon: Icon(EvaIcons.person, size: 24.w),
                  ),
                ],
                onTap: vm.changeSelectedIndex,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _showUploadOptions,
                shape: StadiumBorder(
                  side: BorderSide(color: Colors.white, width: 4.w),
                ),
                child: Icon(EvaIcons.cloud_upload_outline, size: 30.w),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
      ),
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      backgroundColor:
          viewModel.themeProvider!.isDark()
              ? MyTheme.darkBlue
              : MyTheme.whiteBlue,
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: MyTheme.lightBlue,
                    size: 24.w,
                  ),
                  title: Text(
                    viewModel.local!.fromGallery,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color:
                          viewModel.themeProvider!.isDark()
                              ? MyTheme.offWhite
                              : MyTheme.blue,
                      fontSize: 16.sp,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.cancel, color: Colors.red, size: 24.w),
                  // Use .w for icon size
                  title: Text(
                    viewModel.local!.cancel,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color:
                          viewModel.themeProvider!.isDark()
                              ? MyTheme.offWhite
                              : MyTheme.blue,
                      fontSize: 16.sp,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(Routes.uploadTabRoute, arguments: File(pickedFile.path));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  HomeViewModel initViewModel() => HomeViewModel();
}
