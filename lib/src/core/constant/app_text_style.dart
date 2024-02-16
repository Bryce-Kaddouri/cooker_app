

import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle lightTextStyle(
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
        fontSize: fontSize ?? 14,
        color: color ?? AppColor.lightBlackTextColor,
        fontWeight: fontWeight ?? FontWeight.w300);
  }

  static TextStyle  regularTextStyle(
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
        fontSize: fontSize ?? 14,
        color: color ?? AppColor.lightBlackTextColor,
        fontWeight: fontWeight ?? FontWeight.normal);
  }

  static TextStyle boldTextStyle(
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
        fontSize: fontSize ?? 14,
        color: color ?? AppColor.lightBlackTextColor,
        fontWeight: fontWeight ?? FontWeight.bold);
  }
}
