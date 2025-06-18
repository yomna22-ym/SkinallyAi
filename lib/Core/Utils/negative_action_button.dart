import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/theme_provider.dart';
import '../Theme/theme.dart';

class NegativeActionButton extends StatelessWidget {
  VoidCallback? negativeAction;
  String negativeActionTitle;

  NegativeActionButton({
    required this.negativeActionTitle,
    this.negativeAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            theme.isDark() ? MyTheme.blue : MyTheme.offWhite,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(width: 2, color: MyTheme.lightBlue),
            ),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          if (negativeAction != null) {
            negativeAction!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FittedBox(
            child: Text(
              negativeActionTitle,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: theme.isDark() ? MyTheme.blue : MyTheme.lightBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
