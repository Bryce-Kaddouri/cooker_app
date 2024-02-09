import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/app_color.dart';
import '../../../../core/helper/date_helper.dart';
import '../provider/order_provider.dart';

class DateBar extends StatelessWidget {
  const DateBar({super.key});

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
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              DateHelper.getFullFormattedDate(
                  context.watch<OrderProvider>().selectedDate!),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.lightBlackTextColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor,
            ),
            child: InkWell(
              onTap: () async {
                DateTime? date =
                await context.read<OrderProvider>().chooseDate();
                if (date != null) {
                  context.read<OrderProvider>().setSelectedDate(date);
                }
              },
              child: Icon(
                Icons.calendar_month_outlined,
                color: AppColor.lightBlackTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}