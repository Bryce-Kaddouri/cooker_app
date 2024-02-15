import 'dart:ui';

import 'package:cooker_app/src/core/constant/app_color.dart';

class AppTextStyle {
  static lightTextStyle(
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
        fontSize: fontSize ?? 14,
        color: color ?? AppColor.lightBlackTextColor,
        fontWeight: fontWeight ?? FontWeight.w300);
  }

  static regularTextStyle(
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
        fontSize: fontSize ?? 14,
        color: color ?? AppColor.lightBlackTextColor,
        fontWeight: fontWeight ?? FontWeight.normal);
  }

  static boldTextStyle(
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
        fontSize: fontSize ?? 14,
        color: color ?? AppColor.lightBlackTextColor,
        fontWeight: fontWeight ?? FontWeight.bold);
  }
}
