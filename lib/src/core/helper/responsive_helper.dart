import 'package:flutter/material.dart';

class ResponsiveHelper {
  static isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 900;
  static isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;
}
