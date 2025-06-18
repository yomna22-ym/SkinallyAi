import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinally_aii/Presentation/Ui/AiAssistant/widgets/ai_form_step.dart';
import 'package:skinally_aii/Presentation/Ui/AiAssistant/widgets/drop_down_option.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import '../../../Core/routes_manager/routes.dart';
import '../Widgets/custom_text_form_field.dart';
import 'ai_navigator.dart';
import 'ai_view_model.dart';

class AiView extends StatefulWidget {
  final String? diagnosis;
  final String userName;

  const AiView({super.key, this.diagnosis, required this.userName});

  @override
  State<AiView> createState() => _AiViewState();
}

class _AiViewState extends BaseState<AiView, AiViewModel> implements AiNavigator {
  @override
  AiViewModel initViewModel() {
    return AiViewModel(
      userName: widget.userName,
      initialDiagnosis: widget.diagnosis,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<AiViewModel>(
        builder: (context, value, child) => Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [MyTheme.lightBlue, MyTheme.whiteBlue],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Container(
                  margin: REdgeInsets.all(20),
                  constraints: BoxConstraints(
                    maxWidth: 400.w,
                    maxHeight: 600.h,
                  ),
                  decoration: BoxDecoration(
                    color: viewModel.themeProvider!.isDark()
                        ? MyTheme.darkBlue
                        : MyTheme.whiteBlue,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: PageView(
                            controller: viewModel.pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildAgeStep(),
                              _buildGenderStep(),
                              _buildBodyAreaStep(),
                              _buildSkinTypeStep(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgeStep() {
    return AiFormStep(
      question: "🎂 ${viewModel.local!.howOldAreYou}",
      onDone: viewModel.nextStep,
      child: CustomTextFormField(
        controller: viewModel.ageController,
        inputType: TextInputType.number,
        label: viewModel.local!.enterYourAge,
        validator: (value) => null,
      ),
    );
  }

  Widget _buildGenderStep() {
    return AiFormStep(
      question: "🚻 ${viewModel.local!.whatIsYourGender}",
      onDone: viewModel.nextStep,
      child: CustomDropdown(
        value: viewModel.getGenderDisplayText(),
        isOpen: viewModel.isGenderDropdownOpen,
        onTap: viewModel.toggleGenderDropdown,
        options: viewModel.genderOptions
            .map(
              (option) => DropdownOption(
            value: option,
            displayText: option,
            onTap: () => viewModel.selectGender(option),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildBodyAreaStep() {
    return AiFormStep(
      question: "📍 ${viewModel.local!.whereIsAffectedArea}",
      onDone: viewModel.nextStep,
      child: CustomTextFormField(
        controller: viewModel.bodyAreaController,
        inputType: TextInputType.text,
        label: viewModel.local!.exampleFaceArmsBack,
        validator: (value) => null,
      ),
    );
  }

  Widget _buildSkinTypeStep() {
    return AiFormStep(
      question: "🧴 ${viewModel.local!.whatIsYourSkinType}",
      onDone: viewModel.nextStep,
      buttonText: viewModel.local!.startConsultation,
      child: CustomDropdown(
        value: viewModel.getSkinTypeDisplayText(),
        isOpen: viewModel.isSkinTypeDropdownOpen,
        onTap: viewModel.toggleSkinTypeDropdown,
        options: viewModel.skinTypeOptions
            .map(
              (option) => DropdownOption(
            value: option,
            displayText: option,
            onTap: () => viewModel.selectSkinType(option),
          ),
        )
            .toList(),
      ),
    );
  }

  @override
  void goToChatScreen({
    required String userName,
    required String userAge,
    required String gender,
    required String skinType,
    required String bodyArea,
    required String diagnosis,
  }) {
    Navigator.pushReplacementNamed(
      context,
      Routes.chatRoute,
      arguments: {
        'userName': userName,
        'userAge': userAge,
        'gender': gender,
        'skinType': skinType,
        'bodyArea': bodyArea,
        'diagnosis': diagnosis,
      },
    );
  }

  @override
  void goBack() {
    Navigator.pop(context);
  }
}
