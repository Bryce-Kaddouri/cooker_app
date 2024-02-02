import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:cooker_app/src/features/order/presentation/widget/date_item_widget.dart';
import 'package:cooker_app/src/features/order/presentation/widget/drawer_widget.dart';

import '../../data/model/order_model.dart';
import '../provider/order_provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController _mainScrollController = ScrollController();
  ScrollController _testController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<DateTime?> selectDate() async {
    // global key for the form
    return showDatePicker(
        context: context,
        currentDate: context.read<OrderProvider>().selectedDate,
        initialDate: context.read<OrderProvider>().selectedDate,
        // first date of the year
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      body: CustomScrollView(controller: _mainScrollController, slivers: [
        SliverAppBar(
          actions: [
            IconButton(
              onPressed: () async {
                DateTime now = DateTime.now();
                context.read<OrderProvider>().setSelectedDate(now);
              },
              icon: const Icon(Icons.calendar_today),
            ),
            IconButton(
              onPressed: () async {
                await selectDate().then((value) {
                  if (value != null) {
                    context.read<OrderProvider>().setSelectedDate(value);
                  }
                });
              },
              icon: const Icon(Icons.edit_calendar),
            ),
          ],
          collapsedHeight: 60,
          pinned: true,
          floating: true,
          expandedHeight: 140,
          backgroundColor: Colors.blue,
          centerTitle: false,
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(DateHelper.getMonthNameAndYear(
                context.watch<OrderProvider>().selectedDate!)),
          ]),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
/*
                      clipBehavior: Clip.none,
*/
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          stops: [
                            0.0,
                            0.9,
                            0.9,
                            1.0,
                          ],
                          colors: [
                            Colors.blue,
                            Colors.blue,
                            Colors.white,
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      width: double.infinity,
                      height: 80,
                      child: GridView(
                          controller: _testController,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 0,
                            mainAxisExtent: 80,
                          ),
                          children: [
                            for (DateTime dateItem in DateHelper.getDaysInWeek(
                                context.read<OrderProvider>().selectedDate!))
                              DateItemWidget(
                                selectedDate:
                                    context.read<OrderProvider>().selectedDate!,
                                value: 'test',
                                dateItem: dateItem,
                              ),
                          ]),
                    ),
                  ],
                )),
          ),
        ),
        FutureBuilder(
          future: context
              .read<OrderProvider>()
              .getOrdersByDate(context.read<OrderProvider>().selectedDate!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> lstHourMap = [];

                List<OrderModel> orderList = snapshot.data as List<OrderModel>;
                print('order list length');
                print(orderList.length);
                List<int> lstHour = List.generate(24, (index) => index);

                double sum = 0;
                for (var hour in lstHour) {
                  double height = 60;
                  List<OrderModel> orderListOfTheHour = orderList
                      .where((element) => element.time.hour == hour)
                      .toList();
                  height = height + (orderListOfTheHour.length * height);
                  sum = sum + height;
                  Map<String, dynamic> map = {
                    'hour': hour,
                    'order': orderListOfTheHour,
                    'position': sum,
                  };
                  lstHourMap.add(map);
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Map<String, dynamic> data = lstHourMap[index];
                      return Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: Text(
                              '${data['hour']} h',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: 60,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: List.generate(
                                  data['order'].length,
                                  (index2) {
                                    OrderModel orderModel =
                                        data['order'][index2] as OrderModel;
                                    return Card(
                                      color: Colors.red,
                                      child: Container(
                                        height: 80,
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Text(
                                                '${orderModel.time.format(context)}'),
                                            Text(
                                                '${orderModel.customer!.fName} ${orderModel.customer!.lName}'),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: lstHourMap.length,
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("No order"),
                  ),
                );
              }
            } else {
              return SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        )
      ]),
    );
  }
}

class HorizontalSliverList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets listPadding;
  final Widget? divider;

  const HorizontalSliverList({
    required this.children,
    this.listPadding = const EdgeInsets.all(8),
    this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: listPadding,
          child: Row(children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1) addDivider(),
            ],
          ]),
        ),
      ),
    );
  }

  Widget addDivider() =>
      divider ?? Padding(padding: const EdgeInsets.symmetric(horizontal: 8));
}
