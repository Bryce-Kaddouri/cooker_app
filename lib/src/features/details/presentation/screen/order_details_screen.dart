import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../core/constant/app_text_style.dart';
import '../../../../core/helper/date_helper.dart';
import '../../../order/presentation/screen/order_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${orderId}',
            style: AppTextStyle.boldTextStyle(fontSize: 32)),
      ),
      body: Container(
        color: AppColor.lightCardColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 10, top: 20, bottom: 20),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: AppColor.lightBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColor.lightCardColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text('5 items',
                          style: AppTextStyle.boldTextStyle(fontSize: 20)),
                    ),
                    Expanded(
                        child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                activeColor: AppColor.completedForegroundColor,
                                secondary: Container(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.fastfood, size: 40),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '2',
                                            style: AppTextStyle.boldTextStyle(
                                                fontSize: 24),
                                          ),
                                        ),
                                      ),
                                      Text('x',
                                          style: AppTextStyle.lightTextStyle(
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                                title: Text('Item ${index + 1}',
                                    style: AppTextStyle.boldTextStyle(
                                        fontSize: 16)),
                                checkColor: AppColor.lightBackgroundColor,
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                subtitle: Text(
                                    'Description of item ${index + 1}',
                                    style: AppTextStyle.lightTextStyle(
                                        fontSize: 14)),
                                value: index % 2 == 0,
                                onChanged: (value) {},
                              ),
                              Divider(
                                color: AppColor.lightCardColor,
                              )
                            ],
                          ),
                        );
                      },
                    )),
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 20, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColor.lightBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(Icons.person_outlined, size: 50),
                            Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Customer',
                                        style: AppTextStyle.lightTextStyle(
                                            fontSize: 12)),
                                    Text('Bryce Kaddouri',
                                        style: AppTextStyle.boldTextStyle(
                                            fontSize: 20)),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(Icons.access_time_outlined, size: 50),
                            Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Hour',
                                        style: AppTextStyle.lightTextStyle(
                                            fontSize: 12)),
                                    Text('11 : 30',
                                        style: AppTextStyle.boldTextStyle(
                                            fontSize: 20)),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(
                      left: 10, right: 20, top: 20, bottom: 20),
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: AppColor.lightBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(children: [
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: StatusWidget(
                              status: 'Pending',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                              '${DateHelper.getFormattedDateAndTime(DateTime.now())}',
                              style: AppTextStyle.lightTextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: AppColor.lightCardColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            child: StatusWidget(
                              status: 'Cooking',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                              '${DateHelper.getFormattedDateAndTime(DateTime.now())}',
                              style: AppTextStyle.lightTextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: AppColor.lightCardColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            child: StatusWidget(
                              status: 'Completed',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                              '${DateHelper.getFormattedDateAndTime(DateTime.now())}',
                              style: AppTextStyle.lightTextStyle(fontSize: 16)),
                        ],
                      ),
                    )),
                    MaterialButton(
                      onPressed: () {},
                      child: Text('Mark as completed',
                          style: AppTextStyle.boldTextStyle(fontSize: 20)),
                      color: AppColor.completedForegroundColor,
                      height: 60,
                      minWidth: double.infinity,
                    ),
                  ]),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
