import 'package:cooker_app/src/core/constant/app_text_style.dart';
import 'package:cooker_app/src/core/helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  List<int> nbOrdersByStatus;
  int selectedIndex;
  StatusBar(
      {super.key, required this.selectedIndex, required this.nbOrdersByStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            height: 40,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selectedIndex == 0 ? Theme.of(context).primaryColor : null,
            ),
            child: InkWell(
              child: Text('All (23)', style: TextStyle(fontSize: 2)
                  /* ResponsiveBreakpoints.of(context).between(MOBILE, TABLET)
                          ? AppTextStyle.lightTextStyle(fontSize: 32)
                          : AppTextStyle.regularTextStyle()),*/
                  ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selectedIndex == 1 ? Theme.of(context).primaryColor : null,
            ),
            child: Text(
              'Pending (13)',
              style: !ResponsiveHelper.isDesktop(context)
                  ? AppTextStyle.lightTextStyle(fontSize: 10)
                  : AppTextStyle.regularTextStyle(),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selectedIndex == 1 ? Theme.of(context).primaryColor : null,
            ),
            child: Text(
              'Cooking (3)',
              style: !ResponsiveHelper.isDesktop(context)
                  ? AppTextStyle.lightTextStyle(fontSize: 10)
                  : AppTextStyle.regularTextStyle(),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selectedIndex == 1 ? Theme.of(context).primaryColor : null,
            ),
            child: Text(
              'Completed (7)',
              style: !ResponsiveHelper.isDesktop(context)
                  ? AppTextStyle.lightTextStyle(fontSize: 10)
                  : AppTextStyle.regularTextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
