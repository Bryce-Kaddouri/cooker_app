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
                    backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
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
                      elevation: 4,
                      shadowColor: FluentTheme.of(context).shadowColor,
                      surfaceTintColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
                      backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
                      toolbarHeight: 70,
                      title: /*Container(
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
                          mainAxisAlignment: !ResponsiveHelper.isDesktop(context) ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                          children: [
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
                      ),*/
                          DateBar(
                        selectedDate: widget.selectedDate,
                      ),
                      actions: [
                        Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: FluentTheme.of(context).cardColor,
                          ),
                          child: material.InkWell(
                            onTap: () async {
                              DateTime? date = await context.read<OrderProvider>().chooseDate(context, widget.selectedDate);
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
                        SizedBox(
                          width: 8,
                        ),
                        if (!ResponsiveHelper.isDesktop(context))
                          material.SearchAnchor(
                              isFullScreen: true,
/*
                                searchController: searchController,
*/
                              builder: (context, searchController) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  height: 50,
                                  width: 50,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: FluentTheme.of(context).cardColor,
                                  ),
                                  child: Icon(
                                    FluentIcons.search,
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
                      ],
                    ),
                    body: CustomScrollView(slivers: [
                      SliverPersistentHeader(
                        floating: true,
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          isDesktop: ResponsiveHelper.isDesktop(context),
                          child: Container(
                            height: 80,
                            color: FluentTheme.of(context).scaffoldBackgroundColor,
                            child: Column(children: [
                              if (!ResponsiveHelper.isDesktop(context))
                                Container(
                                  height: 70,
                                  padding: ResponsiveHelper.isMobile(context) ? const EdgeInsets.all(0) : const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: StatusBar(nbOrders: nbOrders),
                                      ),
                                    ],
                                  ),
                                ),
                              /* Container(
                                height: 70,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Card(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order List',
                                        style: FluentTheme.of(context).typography.bodyLarge!.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
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
*/ /*
                                                fillColor: Theme.of(context).primaryColor,
*/ /*
                                                  filled: true,
                                                  */ /* hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      fontSize: 16,
                                                    ),*/ /*
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
                              ),*/
                            ]),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 170 : MediaQuery.of(context).size.height - 300,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
/*
                            color: FluentTheme.of(context).cardColor,
*/
                          ),
                          child: orders.isNotEmpty
                              ? Column(
                                  children: [
                                    // pending orders
                                    if (pendingOrders.isNotEmpty && (context.watch<FilterProvider>().selectedStatus == Status.all || context.watch<FilterProvider>().selectedStatus == Status.pending))
                                      OrdersItemViewByStatus(
                                        status: 'pending',
                                        orders: pendingOrders,
                                      ),
                                    if (cookingOrders.isNotEmpty && (context.watch<FilterProvider>().selectedStatus == Status.all || context.watch<FilterProvider>().selectedStatus == Status.cooking))
                                      OrdersItemViewByStatus(
                                        status: 'inProgress',
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
                      ),
                    ]));
              }
          }
        });
  }
}

class StatusBar extends StatelessWidget {
  List<int> nbOrders;
  StatusBar({super.key, required this.nbOrders});

  // global key to manage the state button of pending status

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
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /*Container(
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
                ),*/
                Button(
                    style: ButtonStyle(
                      elevation: ButtonState.all(4),
                      shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.red, width: 1))),
                      padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                      backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.all ? FluentTheme.of(context).scaffoldBackgroundColor : null),
                    ),
                    child: Text('All (${nbOrders[0]})'),
                    onPressed: () {
                      context.read<FilterProvider>().setSelectedStatus(Status.all);
                    }),
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
/*
            padding: const EdgeInsets.all(5),
*/
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              /* borderRadius: BorderRadius.circular(25),*/
              color: FluentTheme.of(context).cardColor,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Button(
                      style: ButtonStyle(
                        elevation: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.all ? 2 : 0),
                        shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!, width: 1))),
                        padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                        backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.all ? FluentTheme.of(context).navigationPaneTheme.backgroundColor : null),
                      ),
                      child: Text('All (${nbOrders[0]})'),
                      onPressed: () {
                        context.read<FilterProvider>().setSelectedStatus(Status.all);
                      }),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Button(
                      style: ButtonStyle(
                        shadowColor: ButtonState.all(AppColor.pendingForegroundColor),
                        elevation: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.pending ? 2 : 0),
                        shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColor.pendingForegroundColor, width: 1))),
                        padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                        backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.pending ? AppColor.pendingBackgroundColor : null),
                      ),
                      child: Text('Pending (${nbOrders[1]})', style: TextStyle(color: AppColor.pendingForegroundColor, fontWeight: context.watch<FilterProvider>().selectedStatus == Status.pending ? FontWeight.bold : FontWeight.normal)),
                      onPressed: () {
                        context.read<FilterProvider>().setSelectedStatus(Status.pending);
                      }),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Button(
                      style: ButtonStyle(
                        elevation: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.cooking ? 2 : 0),
                        shadowColor: ButtonState.all(AppColor.cookingForegroundColor),
                        shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColor.cookingForegroundColor, width: 1))),
                        padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                        backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.cooking ? AppColor.cookingBackgroundColor : null),
                      ),
                      child: Text('In Progress (${nbOrders[2]})', style: TextStyle(color: AppColor.cookingForegroundColor, fontWeight: context.watch<FilterProvider>().selectedStatus == Status.cooking ? FontWeight.bold : FontWeight.normal)),
                      onPressed: () {
                        context.read<FilterProvider>().setSelectedStatus(Status.cooking);
                      }),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Button(
                      style: ButtonStyle(
                        elevation: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.completed ? 2 : 0),
                        shadowColor: ButtonState.all(AppColor.completedForegroundColor),
                        shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColor.completedForegroundColor, width: 1))),
                        padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                        backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.completed ? AppColor.completedBackgroundColor : null),
                      ),
                      child: Text('Completed (${nbOrders[3]})', style: TextStyle(color: AppColor.completedForegroundColor, fontWeight: context.watch<FilterProvider>().selectedStatus == Status.completed ? FontWeight.bold : FontWeight.normal)),
                      onPressed: () {
                        context.read<FilterProvider>().setSelectedStatus(Status.completed);
                      }),
                ),
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
    return /*Container(
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
            child:*/
        Text(
      ResponsiveHelper.isMobile(context) ? DateHelper.getFullFormattedDateReduce(selectedDate) : DateHelper.getFullFormattedDate(selectedDate),
      style: FluentTheme.of(context).typography.body!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
      /*),
          ),
        ],
      ),*/
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

  String getStatusName() {
    switch (status) {
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
        return 'Pending';
      case 'inProgress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
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
        getStatusName(),
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
      margin: const EdgeInsets.only(bottom: 40),
      child: Expander(
        initiallyExpanded: true,
        header: Container(
          child: Row(
            children: [
              StatusWidget(status: status),
              SizedBox(width: 10),
              Text(
                '(${orders.length})',
                style: FluentTheme.of(context).typography.body!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        content: Container(
          child: Column(
            children: List.generate(
              orders.length,
              (index) => OrderItemWidget(order: orders[index]),
            ),
          ),
        ),
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
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        onPressed: () {
          int orderId = order.id;
          context.goNamed('order-details', pathParameters: {'id': orderId.toString(), 'date': DateHelper.getFormattedDate(order.date)});
        },
        trailing: Container(
          alignment: Alignment.center,
          child: Icon(FluentIcons.chevron_right_small, size: 12),
        ),
        leading: Text(
          '#${order.id}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        '${order.customer.lName} ${order.customer.fName}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (!ResponsiveHelper.isMobile(context))
                    Container(
                      alignment: Alignment.center,
                      child: Text('${order.nbTotalItemsCart}'),
                    ),
                  if (!ResponsiveHelper.isMobile(context))
                    Container(
                      alignment: Alignment.center,
                      child: Text('${PriceHelper.getFormattedPrice(
                        order.totalAmount,
                        showBefore: false,
                      )}'),
                    ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      DateHelper.get24HourTime(order.time),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
  double get maxExtent => isDesktop ? 70 : 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
