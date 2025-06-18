import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import '../Widgets/custom_text_form_field.dart';
import 'edit_profile_navigator.dart';
import 'edit_profile_view_model.dart';

class EditProfileView extends StatefulWidget {
  static const String routeName = "EditProfile";

  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState
    extends BaseState<EditProfileView, EditProfileViewModel>
    implements EditProfileNavigator {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.local!.editProfile)),
      body: ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<EditProfileViewModel>(
          builder: (context, value, child) {
            if (value.errorMessage != null) {
              return Center(
                child: Text(
                  value.errorMessage!,
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium!.copyWith(fontSize: 16.sp),
                ),
              );
            } else {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Form(
                    key: value.formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          label: value.local!.name,
                          controller: value.nameController,
                          inputType: TextInputType.name,
                          validator: value.nameValidation,
                          icon: EvaIcons.person,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextFormField(
                          label: value.local!.phone,
                          controller: value.phoneController,
                          inputType: TextInputType.phone,
                          validator: value.phoneValidation,
                          icon: EvaIcons.phone,
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              width: 2.w,
                              color: MyTheme.lightBlue,
                            ),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            // Keep as is
                            underline: const SizedBox(),
                            // Keep const
                            value: value.selectedGender,
                            style: Theme.of(context).textTheme.displayMedium!
                                .copyWith(fontSize: 16.sp),

                            borderRadius: BorderRadius.circular(12.r),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            icon: Icon(
                              EvaIcons.arrow_down,
                              color: MyTheme.lightBlue,

                              size: 24.w,
                            ),
                            items:
                                value.genders.map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,

                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.h,
                                      ),
                                      child: Text(gender),
                                    ),
                                  );
                                }).toList(),
                            onChanged:
                                (gender) => value.changeSelectedGender(
                                  gender ?? "Select Gender",
                                ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Date Picker
                        InkWell(
                          onTap: value.showDatePicker,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 12.h,
                            ),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                width: 2.w,
                                color: MyTheme.lightBlue,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  EvaIcons.calendar,
                                  color: MyTheme.lightBlue,

                                  size: 30.w,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  value.selectedDate,
                                  // Text comes from ViewModel
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontSize: 16.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),

                        ElevatedButton(
                          onPressed: value.updateUserData,

                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            viewModel.local!.updateAccount,

                            style: Theme.of(
                              context,
                            ).textTheme.displayMedium!?.copyWith(
                              color: MyTheme.offWhite,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  EditProfileViewModel initViewModel() {
    return EditProfileViewModel();
  }

  @override
  Future<void> showCustomDatePicker() async {
    DateTime? newDateTime = await showRoundedDatePicker(
      context: context,
      initialDate: viewModel.birthDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
      borderRadius: 16.r,
      height: 300.h,
      barrierDismissible: false,
      styleDatePicker: MaterialRoundedDatePickerStyle(
        backgroundActionBar: MyTheme.offWhite,
        backgroundHeader: MyTheme.lightBlue,
        colorArrowNext: MyTheme.lightBlue,
        colorArrowPrevious: MyTheme.lightBlue,
        textStyleButtonAction: TextStyle(
          fontSize: 16.sp,
          color: MyTheme.lightBlue,
        ),
        textStyleMonthYearHeader: TextStyle(
          fontSize: 16.sp,
          color: MyTheme.lightBlue,
        ),
        textStyleDayOnCalendarSelected: TextStyle(
          fontSize: 16.sp,
          color: MyTheme.offWhite,
        ),
        textStyleDayOnCalendarDisabled: TextStyle(
          fontSize: 16.sp,
          color: MyTheme.lightBlue,
        ),
        textStyleYearButton: TextStyle(
          fontSize: 16.sp,
          color: MyTheme.offWhite,
        ),
        textStyleDayOnCalendar: TextStyle(
          fontSize: 16.sp,
          color: MyTheme.darkBlue,
        ),
        textStyleDayHeader: TextStyle(fontSize: 16.sp, color: MyTheme.darkBlue),
        textStyleDayButton: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
          color: MyTheme.offWhite,
        ),
        textStyleCurrentDayOnCalendar: TextStyle(
          fontSize: 16.sp,
          color: MyTheme.lightBlue,
        ),
        textStyleButtonPositive: TextStyle(
          fontSize: 16.sp,
          color: MyTheme.lightBlue,
        ),
        textStyleButtonNegative: TextStyle(
          fontSize: 16.sp,
          color: MyTheme.lightBlue,
        ),
        backgroundHeaderMonth: MyTheme.offWhite,
        backgroundPicker: MyTheme.offWhite,
        decorationDateSelected: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: MyTheme.lightBlue,
        ),
      ),
    );
    viewModel.changeDate(newDateTime);
  }
}
