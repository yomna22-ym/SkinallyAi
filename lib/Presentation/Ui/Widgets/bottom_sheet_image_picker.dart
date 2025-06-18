import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Core/Providers/theme_provider.dart';
import '../../../Core/Theme/theme.dart';

class MyBottomSheetWidget extends StatelessWidget {
  String title ;
  String galleryTitle;
  Function pickImageFromGallery;
  MyBottomSheetWidget({
    required this.title ,
    required this.galleryTitle,
    required this.pickImageFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Center(
          child: FittedBox(
            child: Text(
              title,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDark()? MyTheme.offWhite : MyTheme.lightBlue,
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            Center(
              child: Expanded(
                child:ElevatedButton(
                  onPressed: (){
                    pickImageFromGallery();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FittedBox(child: Text(galleryTitle,)),
                  ),
                )
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
