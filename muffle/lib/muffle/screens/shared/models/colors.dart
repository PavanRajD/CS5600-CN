   import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can instantiate this class

  static const List<Color> accentColors = [
    Color(0xFF9785C2),
    Color(0xFFEC8686),
    Color(0xFF98B433),
    Color(0xFF64C3D1),
    Color(0xFFC2B89D),
    Color(0xFFF1C533),
    Color(0xFFCB7CC0),
    Color(0xFF5D9ED3),
  ];

  static Color getRandomAccentColor() => accentColors[Random().nextInt(100) % 8];
}
