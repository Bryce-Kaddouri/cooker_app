import 'dart:math' as math;

import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:cooker_app/src/core/helper/date_helper.dart';
import 'package:cooker_app/src/core/helper/price_helper.dart';
import 'package:cooker_app/src/features/category/model/category_model.dart';
import 'package:cooker_app/src/features/order/data/datasource/order_datasource.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';
import 'package:cooker_app/src/features/order/presentation/widget/filter_widget.dart';
import 'package:cooker_app/src/features/order/presentation/widget/sort_by_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../product/data/model/product_model.dart';
import '../provider/filter_provider.dart';
import '../provider/order_provider.dart';
import '../provider/sort_provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  /* ScrollController _mainScrollController = ScrollController();
  ScrollController _testController = ScrollController();*/

  @override
  void initState() {
    super.initState();
    print('initState');
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
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

  List<ProductModel> allProductofTheDay = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderDataSource().getOrdersStream(
            context.watch<OrderProvider>().selectedDate!,
            context.watch<SortProvider>().sortType,
            context.watch<SortProvider>().isAscending),

            builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.active:
              if(!snapshot.hasData){
                return Container(
                  alignment: Alignment.center,
                  child: Text("No order"),
                );
              }
              List<OrderModel> orders = snapshot.data as List<OrderModel>;
              List<OrderModel> pendingOrders = orders
                  .where((element) => element.status.name == 'Pending')
                  .toList();
              List<OrderModel> cookingOrders = orders
                  .where((element) => element.status.name == 'Cooking')
                  .toList();
              List<OrderModel> completedOrders = orders
                  .where((element) => element.status.name == 'Completed')
                  .toList();
              List<OrderModel> cancelledOrders = orders
                  .where((element) => element.status.name == 'Cancelled')
                  .toList();
              return CustomScrollView(
                slivers:[
                  SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 70,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: IconButton(
                                    icon: const Icon(Icons.menu),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                StatusBar(selectedIndex: 0),
                                DateBar(),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).cardColor,
                            ),
                            padding: const EdgeInsets.all(10),
                            height: 60,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order List',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColor.lightBlackTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: 350,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        child: Icon(
                                          Icons.search,
                                          color: AppColor.lightBlackTextColor,
                                        ),
                                      ),
                                      TextField(
                                        scrollPadding: const EdgeInsets.all(0),
                                        maxLines: 1,
                                        clipBehavior: Clip.antiAlias,
                                        textAlignVertical: TextAlignVertical.top,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                          constraints: BoxConstraints(
                                            maxWidth: 300,
                                            minHeight: 40,
                                            maxHeight: 40,
                                          ),
                                          hintText: 'Search by order ID',
                                          fillColor: Theme.of(context).primaryColor,
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: AppColor.lightBlackTextColor,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      SortByWidget(),
                                      SizedBox(width: 10),
                                      FilterWidget()

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
          SliverToBoxAdapter(
          child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height - 170,
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Theme.of(context).cardColor,
          ),
          child: Column(
          children: [
          Container(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
          vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).primaryColor,
          ),
          child: Row(
          children: [
          Expanded(
          child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
          Expanded(
          flex: 1,
          child: Container(
          alignment: Alignment.center,
          child: Text('Order ID'),
          ),
          ),
          Expanded(
          flex: 2,
          child: Container(
          alignment: Alignment.center,
          child: Text('Customer'),
          ),
          ),
          Expanded(
          flex: 2,
          child: Container(
          alignment: Alignment.center,
          child: Text('Status'),
          ),
          ),
          Expanded(
          flex: 1,
          child: Container(
          alignment: Alignment.center,
          child: Text('Items'),
          ),
          ),
          Expanded(
          flex: 1,
          child: Container(
          alignment: Alignment.center,
          child: Text('Total'),
          ),
          ),
          Expanded(
          flex: 1,
          child: Container(
          alignment: Alignment.center,
          child: Text('Time'),
          ),
          ),
          ],
          ),
          ),
          SizedBox(width: 40),
          ],
          ),
          ),
          Expanded(
          child: Container(
          padding: const EdgeInsets.symmetric(
          vertical: 10, horizontal: 0),
          width: double.infinity,
          child: orders.isNotEmpty
          ? ListView(
          children: [
          // pending orders
          if (pendingOrders.isNotEmpty)
          OrdersItemViewByStatus(
          status: 'Pending',
          orders: pendingOrders,
          ),
          if (cookingOrders.isNotEmpty)
          OrdersItemViewByStatus(
          status: 'Cooking',
          orders: cookingOrders,
          ),
          if (completedOrders.isNotEmpty)
          OrdersItemViewByStatus(
          status: 'Completed',
          orders: completedOrders,
          ),
          if (cancelledOrders.isNotEmpty)
          OrdersItemViewByStatus(
          status: 'Cancelled',
          orders: cancelledOrders,
          ),
          ],
          )
              : Container(
          alignment: Alignment.center,
          child: Text("No order"),
          ),
          ),
          ),
          ],
          ),
          ),
          )
                ]
              );
            case ConnectionState.waiting:
              return Container(
                height: MediaQuery.of(context).size.height - 200,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            case ConnectionState.none:
              if(snapshot.hasData){
                return Container();
              }else{
                return Container(
                  alignment: Alignment.center,
                  child: Text("No order"),
                );
              }
              default:
                return Container();
          }
          print(snapshot.data);
          return Container();


    }
      ),

    );
  }
}

class StatusBar extends StatelessWidget {
  int selectedIndex;
  StatusBar({super.key, required this.selectedIndex});

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
              color: selectedIndex == 0 ? Theme.of(context).primaryColor : null,
            ),
            child: Text(
              'All (23)',
              style: TextStyle(
                fontSize: 16,
                color: AppColor.lightBlackTextColor,
                fontWeight: FontWeight.normal,
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
              style: TextStyle(
                fontSize: 16,
                color: AppColor.lightBlackTextColor,
                fontWeight: FontWeight.normal,
              ),
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
              style: TextStyle(
                fontSize: 16,
                color: AppColor.lightBlackTextColor,
                fontWeight: FontWeight.normal,
              ),
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
              style: TextStyle(
                fontSize: 16,
                color: AppColor.lightBlackTextColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      ),
    );
  }
}

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

class StatusWidget extends StatelessWidget {
  final String status;
  const StatusWidget({super.key, required this.status});

  Color getBgColor() {
    switch (status) {
      case 'Cancelled':
        return AppColor.canceledBackgroundColor;
      case 'Pending':
        return AppColor.pendingBackgroundColor;
      case 'Cooking':
        return AppColor.cookingBackgroundColor;
      case 'Completed':
        return AppColor.completedBackgroundColor;
      default:
        return Colors.grey;
    }
  }

  Color getFgColor() {
    switch (status) {
      case 'Cancelled':
        return AppColor.canceledForegroundColor;
      case 'Pending':
        return AppColor.pendingForegroundColor;
      case 'Cooking':
        return AppColor.cookingForegroundColor;
      case 'Completed':
        return AppColor.completedForegroundColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: getBgColor(),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: getFgColor(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class OrdersItemViewByStatus extends StatelessWidget {
  final String status;
  final List<OrderModel> orders;
  const OrdersItemViewByStatus(
      {super.key, required this.status, required this.orders});

  double getTotal(int index) {
    double total = 0;
    orders[index].cart.forEach((element) {
      total += element.product.price * element.quantity;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.centerLeft,
            child: Text('$status (${orders.length})'),
          ),
          Container(
            child: Column(
              children: List.generate(
                orders.length,
                (index) => Container(
                  height: 70,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '#${orders[index].id}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                    '${orders[index].customer.lName} ${orders[index].customer.fName}'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: StatusWidget(status: status),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text('${orders[index].nbTotalItemsCart}'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text('${PriceHelper.getFormattedPrice(
                                  getTotal(index),
                                  showBefore: false,
                                )}'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '${orders[index].time.hour} : ${orders[index].time.minute}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Container(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// sliver delegate app bar
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  SliverAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 150;

  @override
  bool shouldRebuild(covariant SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
