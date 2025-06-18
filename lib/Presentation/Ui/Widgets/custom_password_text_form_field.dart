import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../Core/Theme/theme.dart';

class CustomPasswordTextFormField extends StatefulWidget {
  String label;
  TextEditingController controller;
  TextInputType inputType;
  Function validator;
  IconData icon;
  CustomPasswordTextFormField(
      {required this.label,
        required this.controller,
        required this.inputType,
        required this.validator,
        required this.icon
      });

  @override
  State<CustomPasswordTextFormField> createState() => _CustomPasswordTextFormFieldState();
}

class _CustomPasswordTextFormFieldState extends State<CustomPasswordTextFormField> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: textTheme.displayMedium,
      cursorColor: MyTheme.lightBlue,
      keyboardType: widget.inputType,
      validator: (value) => widget.validator(value),
      cursorHeight: 20,
      obscureText: visible,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: widget.label,
        hintStyle: textTheme.displayMedium,
        prefixIcon: Icon(widget.icon , color: MyTheme.lightBlue, size: 30,),
        suffixIcon: InkWell(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
          child: visible
              ? const Icon(
            AntDesign.eye_invisible_fill,
            color: MyTheme.lightBlue,
          )
              : const Icon(
            AntDesign.eye_fill,
            color: MyTheme.lightBlue,
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:const BorderSide(
              width: 2,
              color: MyTheme.lightBlue,
            )),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:const BorderSide(
            width: 2,
            color: MyTheme.lightBlue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 2,
              color: MyTheme.lightBlue,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.red,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.red,
            )),
      ),
    );
  }
}
