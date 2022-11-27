import 'package:flutter/material.dart';

class TextTypography {
  // Headers text typography styles
  static AppTextStyle header1 = AppTextStyle(fontSize: 20.0, fontWeight: FontWeight.w700);
  static AppTextStyle lightheader1 = AppTextStyle(fontSize: 20.0, fontWeight: FontWeight.w500);
  static AppTextStyle header2 = AppTextStyle(fontSize: 18.0, fontWeight: FontWeight.w700);
  static AppTextStyle header3 = AppTextStyle(fontSize: 16.0, fontWeight: FontWeight.w700);

  // Normal text typography styles
  static AppTextStyle textBody = AppTextStyle(fontSize: 15.0, fontWeight: FontWeight.w400);
  static AppTextStyle textBodyStrong = AppTextStyle(fontSize: 15.0, fontWeight: FontWeight.w600);
  static AppTextStyle textSmall = AppTextStyle(fontSize: 14.0, fontWeight: FontWeight.w400);
  static AppTextStyle textSmallStrong = AppTextStyle(fontSize: 14.0, fontWeight: FontWeight.w600);
  static AppTextStyle textXSmall = AppTextStyle(fontSize: 13.0, fontWeight: FontWeight.w400);
  static AppTextStyle textXSmallStrong = AppTextStyle(fontSize: 13.0, fontWeight: FontWeight.w600);
  static AppTextStyle textLabel = AppTextStyle(fontSize: 11.0, fontWeight: FontWeight.w400);
  static AppTextStyle textLabelStrong = AppTextStyle(fontSize: 11.0, fontWeight: FontWeight.w600);
  static AppTextStyle textStatusLabel = AppTextStyle(fontSize: 10.0, fontWeight: FontWeight.w800);
}

class AppTextStyle {
  final double fontSize;
  final FontWeight fontWeight;

  AppTextStyle({
    required this.fontSize,
    required this.fontWeight,
  });
}
