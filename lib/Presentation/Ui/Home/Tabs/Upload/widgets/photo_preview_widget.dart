import 'dart:io';
import 'package:flutter/material.dart';

class PhotoPreviewWidget extends StatelessWidget {
  final String imagePath;

  const PhotoPreviewWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.file(
        File(imagePath),
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      ),
    );
  }
}
