import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class LightTheme {
  final AppColor appColor = AppColor();

  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: AppColor.lightBackgroundColor,
    primaryColor: AppColor.lightBackgroundColor,
    cardColor: AppColor.lightCardColor,
  );
}
