import 'dart:ui';

import 'package:flutter/material.dart';

class ServiceCard {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onClickListener;
  ServiceCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onClickListener,
  });
}
