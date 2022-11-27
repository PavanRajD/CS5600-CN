import 'package:flutter/material.dart';
import 'package:muffle/muffle/core/core.dart';

import '../models/models.dart';

class AppText extends StatelessWidget {
  final String? text;
  final AppTextStyle? appTextStyle;
  final TextAlign textAlign;
  final TextOverflow textOverflow;
  final int? maxLines;
  final Color? color;
  final FontWeight? fontWeight;
  final bool upperCase;

  const AppText({
    super.key,
    required this.text,
    required this.appTextStyle,
    this.textAlign = TextAlign.start,
    this.textOverflow = TextOverflow.ellipsis,
    this.maxLines = 1,
    this.color,
    this.fontWeight,
    this.upperCase = false,
  });

  double getScaleFactor(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return scaleFactor > 1 ? 1.0 : scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text != null && upperCase ? text!.toUpperCase() : text ?? '',
      style: TextStyle(
        fontWeight: fontWeight ?? appTextStyle?.fontWeight,
        fontSize: appTextStyle?.fontSize,
        color: color ?? ColorConstants.primaryColor,
      ),
      textAlign: textAlign,
      textScaleFactor: getScaleFactor(context),
      softWrap: true,
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
