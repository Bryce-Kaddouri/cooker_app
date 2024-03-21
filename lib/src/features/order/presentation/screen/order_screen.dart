import 'dart:async';

import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:cooker_app/src/core/helper/date_helper.dart';
import 'package:cooker_app/src/core/helper/price_helper.dart';
import 'package:cooker_app/src/core/helper/responsive_helper.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';
import 'package:cooker_app/src/features/order/presentation/provider/filter_provider.dart';
import 'package:cooker_app/src/features/status/model/status_model.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../product/data/model/product_model.dart';
import '../../../setting/presentation/setting_provider.dart';
import '../provider/order_provider.dart';
import '../provider/sort_provider.dart';
import '../widget/filter_widget.dart';
import '../widget/sort_by_widget.dart';

class OrderScreen extends StatefulWidget {
  DateTime selectedDate;
  OrderScreen({super.key, required this.selectedDate});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

enum Tables {
  orders,
  products,
  customers,
  categories,
  cart,
}

class _OrderScreenState extends State<OrderScreen> {
  /* ScrollController _mainScrollController = ScrollController();
  ScrollController _testController = ScrollController();*/

  @override
  void initState() {
    super.initState();
    print('initState OrderScreen');

    Supabase.instance.client
        .channel('all_orders_view')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            callback: (payload) async {
              print(' ------------------- payload order-------------------');
              print(payload);
              print(' ------------------- payload -------------------');
              /*initData();*/

              if (payload.eventType == PostgresChangeEvent.insert) {
                if (DateTime.parse(payload.newRecord['date']) == widget.selectedDate) {
                  setState(() {});
                  ElegantNotification.info(
                    title: Text('New Order'),
                    description: Text('Order #${payload.newRecord['id']} has been added'),
                    width: 360,
                    position: Alignment.topRight,
                    animation: AnimationType.fromRight,
                  ).show(context);
                }
              } else if (payload.eventType == PostgresChangeEvent.update) {
                if (DateTime.parse(payload.newRecord['date']) == widget.selectedDate) {
                  setState(() {});
                  ElegantNotification.info(
                    title: Text('Order Updated'),
                    description: Text('Order #${payload.newRecord['id']} has been updated'),
                    width: 360,
                    position: Alignment.topRight,
                    animation: AnimationType.fromRight,
                  ).show(context);
                }
              } else if (payload.eventType == PostgresChangeEvent.delete) {
                if (DateTime.parse(payload.newRecord['date']) == widget.selectedDate) {
                  setState(() {});
                  ElegantNotification.info(
                    title: Text('Order Deleted'),
                    description: Text('Order #${payload.newRecord['id']} has been deleted'),
                    width: 360,
                    position: Alignment.topRight,
                    animation: AnimationType.fromRight,
                  ).show(context);
                }
              }
            })
        .subscribe();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<DateTime?> selectDate() async {
    // global key for the form
    return material.showDatePicker(
        context: context,
        currentDate: widget.selectedDate,
        initialDate: widget.selectedDate,
        // first date of the year
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
  }

  List<ProductModel> allProductofTheDay = [];

  material.SearchController searchController = material.SearchController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: context.read<OrderProvider>().getOrdersByDate(widget.selectedDate, context.watch<SortProvider>().sortType, context.watch<SortProvider>().isAscending),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                color: FluentTheme.of(context).scaffoldBackgroundColor,
                height: MediaQuery.of(context).size.height - 300,
                width: double.infinity,
                alignment: Alignment.center,
                child: ProgressRing(),
              );
            default:
              if (!snapshot.hasData) {
                return Container(
                  alignment: Alignment.center,
                  child: Text("No order"),
                );
              } else {
                List<OrderModel> orders = snapshot.data!;
                if (!ResponsiveHelper.isMobile(context)) {
                  orders = orders.where((element) => element.toStringForSearch().contains(searchController.text.toLowerCase())).toList();
                }

                List<OrderModel> pendingOrders = orders.where((element) => element.status.name == 'pending').toList();
                List<OrderModel> cookingOrders = orders.where((element) => element.status.name == 'inProgress').toList();
                List<OrderModel> completedOrders = orders.where((element) => element.status.name == 'completed').toList();
                print('completedOrders');
                print(completedOrders.length);
                List<OrderModel> cancelledOrders = orders.where((element) => element.status.name == 'cancelled').toList();
                List<int> nbOrders = [orders.length, pendingOrders.length, cookingOrders.length, completedOrders.length];
                return material.Scaffold(
                    drawer: Builder(
                      builder: (context) => material.Drawer(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  material.DrawerHeader(
                                    decoration: BoxDecoration(
                                      border: Border(),
                                    ),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          child: Icon(
                                            FluentIcons.contact,
                                            size: 50,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text('Bryce Kaddouri', style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      FluentIcons.product_catalog,
                                    ),
                                    title: Text('Order List', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      FluentIcons.product_catalog,
                                    ),
                                    title: Text('Recettes', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                    onPressed: () {
                                      context.goNamed('products');
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      FluentIcons.settings,
                                    ),
                                    title: Text('Settings', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                    onPressed: () {
                                      context.goNamed('setting');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: FilledButton(
                                onPressed: () async {
                                  /*material.showAdaptiveDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          icon: Icon(
                                            Icons.warning_amber_rounded,
                                            size: 70,
                                          ),
                                          iconColor: AppColor.canceledForegroundColor,
                                          title: Text(
                                            'Logout',
                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          content: Text(
                                            'Are you sure you want to logout?',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  fontSize: 16,
                                                ),
                                          ),
                                          actionsAlignment: MainAxisAlignment.spaceBetween,
                                          actions: [
                                            MaterialButton(
                                              minWidth: 100,
                                              height: 40,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              color: AppColor.completedForegroundColor,
                                              textColor: Theme.of(context).primaryColor,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                context.read<AuthProvider>().logout();
                                                context.goNamed('login');
                                              },
                                              child: Text(
                                                'Yes',
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ),
                                            MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              color: AppColor.canceledForegroundColor,
                                              textColor: Theme.of(context).primaryColor,
                                              minWidth: 100,
                                              height: 40,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'No',
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });*/
                                  bool? res = await showDialog<bool?>(
                                    context: context,
                                    builder: (context) {
                                      return ContentDialog(
                                        title: Text('Logout'),
                                        content: Text('Are you sure you want to logout?'),
                                        actions: [
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text('Yes'),
                                          ),
                                          Button(child: Text('No'), onPressed: () => Navigator.of(context).pop(false)),
                                        ],
                                      );
                                    },
                                  );
                                  if (res != null && res) {
                                    context.read<AuthProvider>().logout();
                                    context.goNamed('login');
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FluentIcons.sign_out,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text('Logout'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    appBar: material.AppBar(
                      toolbarHeight: 70,
                      title: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        height: 70,
                        decoration: BoxDecoration(
                          color: FluentTheme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: !ResponsiveHelper.isDesktop(context) ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                          children: [
                            if (!ResponsiveHelper.isDesktop(context)) Spacer(),
                            if (!ResponsiveHelper.isDesktop(context))
                              material.SearchAnchor(
                                  isFullScreen: true,
                                  searchController: searchController,
                                  builder: (context, searchController) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      height: 50,
                                      width: 50,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
/*
                                        color: Theme.of(context).cardColor,
*/
                                      ),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: FluentTheme.of(context).scaffoldBackgroundColor,
                                        ),
                                        child: Icon(
                                          FluentIcons.search,
                                        ),
                                      ),
                                    );
                                  },
                                  suggestionsBuilder: (context, searchController) async {
                                    print('searchController.text');
                                    print(searchController.text);
                                    List<OrderModel> orders = await context.read<OrderProvider>().getOrdersByDate(widget.selectedDate, context.read<SortProvider>().sortType, context.read<SortProvider>().isAscending);
                                    List<OrderModel> filteredOrders = orders.where((element) {
                                      print('element.toStringForSearch()');
                                      print(element.toStringForSearch());
                                      return element.toStringForSearch().contains(searchController.text.toLowerCase());
                                    }).toList();
                                    print('filteredOrders');
                                    print(filteredOrders.length);
                                    return List.generate(filteredOrders.length, (index) => Container(padding: EdgeInsets.symmetric(horizontal: 10), child: OrderItemWidget(order: filteredOrders[index])));
                                  }),
                            if (ResponsiveHelper.isDesktop(context))
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: StatusBar(nbOrders: nbOrders),
                                ),
                              ),
                            DateBar(
                              selectedDate: widget.selectedDate,
                            ),
                          ],
                        ),
                      ),
                    ),
                    body: CustomScrollView(slivers: [
                      SliverPersistentHeader(
                        floating: true,
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          isDesktop: ResponsiveHelper.isDesktop(context),
                          child: Container(
                            color: FluentTheme.of(context).scaffoldBackgroundColor,
                            child: Column(children: [
                              if (!ResponsiveHelper.isDesktop(context))
                                Container(
                                  padding: ResponsiveHelper.isMobile(context) ? const EdgeInsets.all(0) : const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                                  child: StatusBar(nbOrders: nbOrders),
                                ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: FluentTheme.of(context).cardColor,
                                ),
                                padding: const EdgeInsets.all(10),
                                height: 60,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Order List',
                                        style: FluentTheme.of(context).typography.bodyLarge!.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )
                                        /* TextStyle(
                                        fontSize: 20,
                                        color: AppColor.lightBlackTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),*/
                                        ),
                                    if (ResponsiveHelper.isDesktop(context))
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: FluentTheme.of(context).scaffoldBackgroundColor,
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
                                                FluentIcons.search,
                                              ),
                                            ),
                                            material.TextField(
                                              showCursor: true,
                                              controller: searchController,
                                              scrollPadding: const EdgeInsets.all(0),
                                              maxLines: 1,
                                              clipBehavior: Clip.antiAlias,
                                              textAlignVertical: TextAlignVertical.top,
                                              decoration: material.InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                                constraints: BoxConstraints(
                                                  maxWidth: 300,
                                                  minHeight: 40,
                                                  maxHeight: 40,
                                                ),
                                                hintText: 'Search by order ID',
/*
                                                fillColor: Theme.of(context).primaryColor,
*/
                                                filled: true,
                                                /* hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      fontSize: 16,
                                                    ),*/
                                                border: material.OutlineInputBorder(
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
                                          SizedBox(width: ResponsiveHelper.isDesktop(context) ? 10 : 5),
                                          FilterWidget(
                                            selectedDate: widget.selectedDate,
                                          )
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
                          height: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 170 : MediaQuery.of(context).size.height - 210,
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: FluentTheme.of(context).cardColor,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: FluentTheme.of(context).scaffoldBackgroundColor,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 60,
                                            alignment: Alignment.center,
                                            child: Text('Order ID'),
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
                                          if (!ResponsiveHelper.isMobile(context))
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text('Items'),
                                              ),
                                            ),
                                          if (!ResponsiveHelper.isMobile(context))
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
                                    SizedBox(width: ResponsiveHelper.isMobile(context) ? 30 : 40),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                  width: double.infinity,
                                  child: orders.isNotEmpty
                                      ? ListView(
                                          children: [
                                            // pending orders
                                            if (pendingOrders.isNotEmpty && (context.watch<FilterProvider>().selectedStatus == Status.all || context.watch<FilterProvider>().selectedStatus == Status.pending))
                                              OrdersItemViewByStatus(
                                                status: 'pending',
                                                orders: pendingOrders,
                                              ),
                                            if (cookingOrders.isNotEmpty && (context.watch<FilterProvider>().selectedStatus == Status.all || context.watch<FilterProvider>().selectedStatus == Status.cooking))
                                              OrdersItemViewByStatus(
                                                status: 'cooking',
                                                orders: cookingOrders,
                                              ),
                                            if (completedOrders.isNotEmpty && (context.watch<FilterProvider>().selectedStatus == Status.all || context.watch<FilterProvider>().selectedStatus == Status.completed))
                                              OrdersItemViewByStatus(
                                                status: 'completed',
                                                orders: completedOrders,
                                              ),
                                            if (cancelledOrders.isNotEmpty && (context.watch<FilterProvider>().selectedStatus == Status.all || context.watch<FilterProvider>().selectedStatus == Status.cancelled))
                                              OrdersItemViewByStatus(
                                                status: 'cancelled',
                                                orders: cancelledOrders,
                                              ),

                                            // if status != all and no order
                                            if (context.watch<FilterProvider>().selectedStatus == Status.pending && pendingOrders.isEmpty)
                                              Container(
                                                height: MediaQuery.of(context).size.height - 300,
                                                alignment: Alignment.center,
                                                child: Text("No Pending Orders"),
                                              ),
                                            if (context.watch<FilterProvider>().selectedStatus == Status.cooking && cookingOrders.isEmpty)
                                              Container(
                                                height: MediaQuery.of(context).size.height - 300,
                                                alignment: Alignment.center,
                                                child: Text("No Cooking Orders"),
                                              ),
                                            if (context.watch<FilterProvider>().selectedStatus == Status.completed && completedOrders.isEmpty)
                                              Container(
                                                height: MediaQuery.of(context).size.height - 300,
                                                alignment: Alignment.center,
                                                child: Text("No Completed Orders"),
                                              ),
                                          ],
                                        )
                                      : Container(
                                          height: MediaQuery.of(context).size.height - 300,
                                          alignment: Alignment.center,
                                          child: Text("No orders"),
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]));
              }
          }
        });
  }
}

class StatusBar extends StatelessWidget {
  List<int> nbOrders;
  StatusBar({super.key, required this.nbOrders});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? Container(
/*
            padding: const EdgeInsets.all(5),
*/
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: FluentTheme.of(context).cardColor,
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
                    color: context.watch<FilterProvider>().selectedStatus == Status.all ? FluentTheme.of(context).scaffoldBackgroundColor : null,
                  ),
                  child: material.InkWell(
                    onTap: () {
                      context.read<FilterProvider>().setSelectedStatus(Status.all);
                    },
                    child: Text(
                      'All (${nbOrders[0]})',
                      style: FluentTheme.of(context).typography.body!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
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
                    color: context.watch<FilterProvider>().selectedStatus == Status.pending ? FluentTheme.of(context).scaffoldBackgroundColor : null,
                  ),
                  child: material.InkWell(
                    onTap: () {
                      context.read<FilterProvider>().setSelectedStatus(Status.pending);
                    },
                    child: Text(
                      'Pending (${nbOrders[1]})',
                      style: FluentTheme.of(context).typography.body!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
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
                    color: context.watch<FilterProvider>().selectedStatus == Status.cooking ? FluentTheme.of(context).scaffoldBackgroundColor : null,
                  ),
                  child: material.InkWell(
                    onTap: () {
                      context.read<FilterProvider>().setSelectedStatus(Status.cooking);
                    },
                    child: Text(
                      'Cooking (${nbOrders[2]})',
                      style: FluentTheme.of(context).typography.body!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
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
                    color: context.watch<FilterProvider>().selectedStatus == Status.completed ? FluentTheme.of(context).scaffoldBackgroundColor : null,
                  ),
                  child: material.InkWell(
                    onTap: () {
                      context.read<FilterProvider>().setSelectedStatus(Status.completed);
                    },
                    child: Text(
                      'Completed (${nbOrders[3]})',
                      style: FluentTheme.of(context).typography.body!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                )
              ],
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(5),
            height: 50,
            decoration: BoxDecoration(
              /* borderRadius: BorderRadius.circular(25),*/
              color: FluentTheme.of(context).cardColor,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.watch<FilterProvider>().selectedStatus == Status.all ? FluentTheme.of(context).scaffoldBackgroundColor : null,
                  ),
                  child: material.InkWell(
                    onTap: () {
                      context.read<FilterProvider>().setSelectedStatus(Status.all);
                    },
                    child: Text(
                      'All (${nbOrders[0]})',
                      style: FluentTheme.of(context).typography.body!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.watch<FilterProvider>().selectedStatus == Status.pending ? FluentTheme.of(context).scaffoldBackgroundColor : null,
                  ),
                  child: material.InkWell(
                    onTap: () {
                      context.read<FilterProvider>().setSelectedStatus(Status.pending);
                    },
                    child: Text(
                      'Pending (${nbOrders[1]})',
                      style: FluentTheme.of(context).typography.body!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.watch<FilterProvider>().selectedStatus == Status.cooking ? FluentTheme.of(context).scaffoldBackgroundColor : null,
                  ),
                  child: material.InkWell(
                    onTap: () {
                      context.read<FilterProvider>().setSelectedStatus(Status.cooking);
                    },
                    child: Text(
                      'Cooking (${nbOrders[2]})',
                      style: FluentTheme.of(context).typography.body!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.watch<FilterProvider>().selectedStatus == Status.completed ? FluentTheme.of(context).scaffoldBackgroundColor : null,
                  ),
                  child: material.InkWell(
                    onTap: () {
                      context.read<FilterProvider>().setSelectedStatus(Status.completed);
                    },
                    child: Text(
                      'Completed (${nbOrders[3]})',
                      style: FluentTheme.of(context).typography.body!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class DateBar extends StatelessWidget {
  final DateTime selectedDate;
  const DateBar({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: FluentTheme.of(context).cardColor,
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
              ResponsiveHelper.isMobile(context) ? DateHelper.getFullFormattedDateReduce(selectedDate) : DateHelper.getFullFormattedDate(selectedDate),
              style: FluentTheme.of(context).typography.body!.copyWith(
                    fontSize: 16,
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
              color: FluentTheme.of(context).scaffoldBackgroundColor,
            ),
            child: material.InkWell(
              onTap: () async {
                DateTime? date = await context.read<OrderProvider>().chooseDate(context, selectedDate);
                if (date != null) {
                  context.goNamed('orders', pathParameters: {
                    'date': DateHelper.getFormattedDate(date),
                  });
                }
              },
              child: Icon(
                FluentIcons.calendar_day,
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
      case 'cancelled':
        return AppColor.canceledBackgroundColor;
      case 'pending':
        return AppColor.pendingBackgroundColor;
      case 'inProgress':
        return AppColor.cookingBackgroundColor;
      case 'completed':
        return AppColor.completedBackgroundColor;
      default:
        return Colors.grey;
    }
  }

  Color getFgColor() {
    switch (status) {
      case 'cancelled':
        return AppColor.canceledForegroundColor;
      case 'pending':
        return AppColor.pendingForegroundColor;
      case 'inProgress':
        return AppColor.cookingForegroundColor;
      case 'completed':
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
        color: context.watch<SettingProvider>().isDarkMode ? getFgColor() : getBgColor(),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: context.watch<SettingProvider>().isDarkMode ? getBgColor() : getFgColor(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class OrdersItemViewByStatus extends StatelessWidget {
  final String status;
  List<OrderModel> orders;
  OrdersItemViewByStatus({super.key, required this.status, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.centerLeft,
            child: Text('${status} (${orders.length})'),
          ),
          Container(
            child: Column(
              children: List.generate(orders.length, (index) => OrderItemWidget(order: orders[index])),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final OrderModel order;
  const OrderItemWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: ResponsiveHelper.isDesktop(context) ? 20 : 5),
      child: material.InkWell(
        onTap: () {
          int orderId = order.id;
          context.goNamed('order-details', pathParameters: {'id': orderId.toString(), 'date': DateHelper.getFormattedDate(order.date)});
        },
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: Text(
                      '#${order.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${order.customer.lName} ${order.customer.fName}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: StatusWidget(status: order.status.name),
                    ),
                  ),
                  if (!ResponsiveHelper.isMobile(context))
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('${order.nbTotalItemsCart}'),
                      ),
                    ),
                  if (!ResponsiveHelper.isMobile(context))
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('${PriceHelper.getFormattedPrice(
                          order.totalAmount,
                          showBefore: false,
                        )}'),
                      ),
                    ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${order.time.hour} : ${order.time.minute}',
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
              width: ResponsiveHelper.isMobile(context) ? 30 : 40,
              child: Container(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(FluentIcons.forward, size: 20),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// sliver delegate app bar
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  bool isDesktop;
  SliverAppBarDelegate({required this.child, required this.isDesktop});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  // 150 for desktop else 200
  @override
  double get maxExtent => isDesktop ? 70 : 130;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
