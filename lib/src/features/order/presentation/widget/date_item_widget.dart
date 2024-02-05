import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/helper/date_helper.dart';
import '../provider/order_provider.dart';

class DateItemWidget extends StatelessWidget {
  DateTime selectedDate;
  String value;
  DateTime dateItem;
  DateItemWidget(
      {super.key,
      required this.selectedDate,
      required this.value,
      required this.dateItem});

  @override
  Widget build(BuildContext context) {
    bool isToday = selectedDate.isAtSameMomentAs(dateItem);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: isToday ? 5 : 0,
      color: isToday ? Colors.white : Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<OrderProvider>().setSelectedDate(dateItem);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          height: isToday ? 70 : 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isToday)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              Text(
                dateItem.day.toString(),
                style: TextStyle(
                  color: isToday ? Colors.black : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                DateHelper.getFullFormattedDate(dateItem),
                style: TextStyle(
                    color: isToday ? Colors.black : Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
