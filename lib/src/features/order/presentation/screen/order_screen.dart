import 'dart:async';

import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:cooker_app/src/core/helper/date_helper.dart';
import 'package:cooker_app/src/core/helper/price_helper.dart';
import 'package:cooker_app/src/core/helper/responsive_helper.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';
import 'package:cooker_app/src/features/order/presentation/provider/filter_provider.dart';
import 'package:cooker_app/src/features/order/presentation/widget/filter_widget.dart';
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

  List<OrderModel> orders = [] /*snapshot.data!*/;
  /*if (!ResponsiveHelper.isMobile(context)) {
  orders = orders.where((element) => element.toStringForSearch().contains(searchController.text.toLowerCase())).toList();
  }*/

  List<OrderModel> pendingOrders = [] /*orders.where((element) => element.status.name == 'pending').toList()*/;
  List<OrderModel> cookingOrders = [] /*orders.where((element) => element.status.name == 'inProgress').toList()*/;
  List<OrderModel> completedOrders = [] /*orders.where((element) => element.status.name == 'completed').toList()*/;
  List<OrderModel> collectedOrders = [];
  late List<int> nbOrders = [0, 0, 0, 0, 0] /*[orders.length, pendingOrders.length, cookingOrders.length, completedOrders.length]*/;
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
                  context.read<OrderProvider>().getOrdersByDate(widget.selectedDate, context.read<SortProvider>().sortType, context.read<SortProvider>().isAscending).then((value) {
                    setState(() {
                      orders = value;
                      pendingOrders = value.where((element) => element.status.name == 'pending').toList();
                      cookingOrders = value.where((element) => element.status.name == 'inProgress').toList();
                      completedOrders = value.where((element) => element.status.name == 'completed').toList();
                      collectedOrders = value.where((element) => element.status.name == 'collected').toList();
                      nbOrders = [orders.length, pendingOrders.length, cookingOrders.length, completedOrders.length, collectedOrders.length];
                    });
                  });
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
                  context.read<OrderProvider>().getOrdersByDate(widget.selectedDate, context.read<SortProvider>().sortType, context.read<SortProvider>().isAscending).then((value) {
                    setState(() {
                      orders = value;
                      pendingOrders = value.where((element) => element.status.name == 'pending').toList();
                      cookingOrders = value.where((element) => element.status.name == 'inProgress').toList();
                      completedOrders = value.where((element) => element.status.name == 'completed').toList();
                      collectedOrders = value.where((element) => element.status.name == 'collected').toList();
                      nbOrders = [orders.length, pendingOrders.length, cookingOrders.length, completedOrders.length, collectedOrders.length];
                    });
                  });
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
                  context.read<OrderProvider>().getOrdersByDate(widget.selectedDate, context.read<SortProvider>().sortType, context.read<SortProvider>().isAscending).then((value) {
                    setState(() {
                      orders = value;
                      pendingOrders = value.where((element) => element.status.name == 'pending').toList();
                      cookingOrders = value.where((element) => element.status.name == 'inProgress').toList();
                      completedOrders = value.where((element) => element.status.name == 'completed').toList();
                      collectedOrders = value.where((element) => element.status.name == 'collected').toList();
                      nbOrders = [orders.length, pendingOrders.length, cookingOrders.length, completedOrders.length, collectedOrders.length];
                    });
                  });
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<OrderProvider>().getOrdersByDate(widget.selectedDate, context.read<SortProvider>().sortType, context.read<SortProvider>().isAscending, notify: true).then((value) {
        for (var val in value) {
          print('val');
          print(val.toJson());
        }
        setState(() {
          orders = value;
          pendingOrders = value.where((element) => element.status.name == 'pending').toList();
          cookingOrders = value.where((element) => element.status.name == 'inProgress').toList();
          completedOrders = value.where((element) => element.status.name == 'completed').toList();

          collectedOrders = value.where((element) => element.status.name == 'collected').toList();
          nbOrders = [orders.length, pendingOrders.length, cookingOrders.length, completedOrders.length, collectedOrders.length];
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // change value of orders if date is changed
  @override
  void didUpdateWidget(covariant OrderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (oldWidget.selectedDate != widget.selectedDate) {
        context.read<OrderProvider>().getOrdersByDate(widget.selectedDate, context.read<SortProvider>().sortType, context.read<SortProvider>().isAscending, notify: true).then((value) {
          setState(() {
            orders = value;
            pendingOrders = value.where((element) => element.status.name == 'pending').toList();
            cookingOrders = value.where((element) => element.status.name == 'inProgress').toList();
            completedOrders = value.where((element) => element.status.name == 'completed').toList();
            collectedOrders = value.where((element) => element.status.name == 'collected').toList();

            nbOrders = [orders.length, pendingOrders.length, cookingOrders.length, completedOrders.length, collectedOrders.length];
          });
        });
      }
    });
  }

  Future<DateTime?> selectDate() async {
    // global key for the form
    return material.showDatePicker(
        barrierColor: Colors.red,
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
    return /*FutureBuilder(
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
                List<int> nbOrders = [orders.length, pendingOrders.length, cookingOrders.length, completedOrders.length];
                return */
        material.Scaffold(
            backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
            drawer: Builder(
              builder: (context) => material.Drawer(
                backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
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
                          ListTile.selectable(
                            selected: true,
                            leading: Icon(
                              FluentIcons.product_catalog,
                            ),
                            title: Text('Order List', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile.selectable(
                            selected: false,
                            leading: Icon(
                              FluentIcons.product_catalog,
                            ),
                            title: Text('Recettes', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                            onPressed: () {
                              context.goNamed('products');
                            },
                          ),
                          ListTile.selectable(
                            selected: false,
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
                        style: ButtonStyle(
                          backgroundColor: ButtonState.all(Colors.red),
                        ),
                        onPressed: () async {
                          bool? res = await showDialog<bool?>(
                            context: context,
                            builder: (context) {
                              return ContentDialog(
                                title: Container(alignment: Alignment.center, child: Text('Logout')),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FluentIcons.warning,
                                      size: 100,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text('Are you sure you want to logout?'),
                                    ),
                                  ],
                                ),
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

                  !ResponsiveHelper.isDesktop(context)
                      ? DateBar(
                          selectedDate: widget.selectedDate,
                        )
                      : Row(
                          children: [
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
                // filtered
                Tooltip(
                  message: 'Filter',
                  displayHorizontally: false,
                  useMousePosition: false,
                  style: const TooltipThemeData(preferBelow: true, verticalOffset: 30),
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Button(
                      style: ButtonStyle(
                        backgroundColor: ButtonState.all(FluentTheme.of(context).cardColor),
                        elevation: ButtonState.all(0),
                        shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      ),
                      onPressed: () async {
                        // display dialog in full screen
                        material.showDialog(
                          context: context,
                          builder: (context) {
                            return material.Dialog.fullscreen(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Filter',
                                          style: FluentTheme.of(context).typography.bodyLarge!.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(
                                            FluentIcons.save_and_close,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(
                                      child: FilterWidget(
                                    selectedDate: widget.selectedDate,
                                  )),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Button(
                                          onPressed: () {},
                                          child: Text('Reset all'),
                                        ),
                                        Button(
                                          onPressed: () {},
                                          child: Text('Apply now'),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(
                        FluentIcons.filter,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                /*),*/
                SizedBox(
                  width: 8,
                ),
                material.SearchAnchor(
                    viewElevation: 0,
                    viewBackgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
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
            body: context.watch<OrderProvider>().isLoading
                ? Center(
                    child: ProgressRing(),
                  )
                : CustomScrollView(slivers: [
                    if (!ResponsiveHelper.isDesktop(context))
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          isDesktop: ResponsiveHelper.isDesktop(context),
                          child: Container(
                            height: 80,
                            color: FluentTheme.of(context).scaffoldBackgroundColor.withOpacity(1),
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
                            ]),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: orders.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
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

                                  if (collectedOrders.isNotEmpty && (context.watch<FilterProvider>().selectedStatus == Status.all || context.watch<FilterProvider>().selectedStatus == Status.collected))
                                    OrdersItemViewByStatus(
                                      status: 'collected',
                                      orders: collectedOrders,
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
                                  if (context.watch<FilterProvider>().selectedStatus == Status.collected && collectedOrders.isEmpty)
                                    Container(
                                      height: MediaQuery.of(context).size.height - 300,
                                      alignment: Alignment.center,
                                      child: Text("No Collected Orders"),
                                    ),
                                ],
                              ))
                          : Container(
                              height: MediaQuery.of(context).size.height - 300,
                              alignment: Alignment.center,
                              child: Text("No orders"),
                            ),
                    ),
                  ]));
    /*    }
          }
        });*/
  }
}

class StatusBar extends StatelessWidget {
  List<int> nbOrders;
  StatusBar({super.key, required this.nbOrders});

  // global key to manage the state button of pending status

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
/*
            padding: const EdgeInsets.all(5),
*/
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        /* borderRadius: BorderRadius.circular(25),*/
        color: !ResponsiveHelper.isDesktop(context) ? FluentTheme.of(context).cardColor : null,
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
                  elevation: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.pending ? 2 : 0),
                  shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColor.pendingForegroundColor, width: 1))),
                  padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                  backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.pending ? AppColor.pendingForegroundColor : null),
                ),
                child: Text('Pending (${nbOrders[1]})', style: TextStyle(color: context.watch<FilterProvider>().selectedStatus == Status.pending ? Colors.white : AppColor.pendingForegroundColor, fontWeight: context.watch<FilterProvider>().selectedStatus == Status.pending ? FontWeight.bold : FontWeight.normal)),
                onPressed: () {
                  context.read<FilterProvider>().setSelectedStatus(Status.pending);
                }),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Button(
                style: ButtonStyle(
                  elevation: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.cooking ? 2 : 0),
                  shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColor.cookingForegroundColor, width: 1))),
                  padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                  backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.cooking ? AppColor.cookingForegroundColor : null),
                ),
                child: Text('In Progress (${nbOrders[2]})', style: TextStyle(color: context.watch<FilterProvider>().selectedStatus == Status.cooking ? Colors.white : AppColor.cookingForegroundColor, fontWeight: context.watch<FilterProvider>().selectedStatus == Status.cooking ? FontWeight.bold : FontWeight.normal)),
                onPressed: () {
                  context.read<FilterProvider>().setSelectedStatus(Status.cooking);
                }),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Button(
                style: ButtonStyle(
                  elevation: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.completed ? 2 : 0),
                  shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColor.completedForegroundColor, width: 1))),
                  padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                  backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.completed ? AppColor.completedForegroundColor : null),
                ),
                child: Text('Completed (${nbOrders[3]})', style: TextStyle(color: context.watch<FilterProvider>().selectedStatus == Status.completed ? Colors.white : AppColor.completedForegroundColor, fontWeight: context.watch<FilterProvider>().selectedStatus == Status.completed ? FontWeight.bold : FontWeight.normal)),
                onPressed: () {
                  context.read<FilterProvider>().setSelectedStatus(Status.completed);
                }),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Button(
                style: ButtonStyle(
                  elevation: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.collected ? 2 : 0),
                  shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColor.collectedForegroundColor, width: 1))),
                  padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                  backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedStatus == Status.collected ? AppColor.collectedForegroundColor : null),
                ),
                child: Text('Collected (${nbOrders[4]})', style: TextStyle(color: context.watch<FilterProvider>().selectedStatus == Status.collected ? Colors.white : AppColor.collectedForegroundColor, fontWeight: context.watch<FilterProvider>().selectedStatus == Status.collected ? FontWeight.bold : FontWeight.normal)),
                onPressed: () {
                  context.read<FilterProvider>().setSelectedStatus(Status.collected);
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
      case 'collected':
        return AppColor.collectBackgroundColor;
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
      case 'collected':
        return AppColor.collectedForegroundColor;
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
      case 'collected':
        return 'Collected';
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
        color: getFgColor(),
      ),
      child: Text(
        getStatusName(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NbOrderWidget extends StatelessWidget {
  final String status;
  final int nbOrder;
  const NbOrderWidget({super.key, required this.status, required this.nbOrder});

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
      case 'collected':
        return AppColor.collectBackgroundColor;
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
      case 'collected':
        return AppColor.collectedForegroundColor;
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
        color: getFgColor(),
      ),
      child: Text(
        nbOrder.toString(),
        style: TextStyle(
          color: Colors.white,
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
              NbOrderWidget(status: status, nbOrder: orders.length),
              /*Text(
                '(${orders.length})',
                style: FluentTheme.of(context).typography.body!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),*/
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
      padding: EdgeInsets.all(0),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
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
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text('${order.nbTotalItemsCart} items'),
                    ),
                  if (!ResponsiveHelper.isMobile(context))
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text('${PriceHelper.getFormattedPrice(
                        order.totalAmount,
                        showBefore: false,
                      )}'),
                    ),
                  Container(
                    padding: const EdgeInsets.all(20),
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
    return oldDelegate != this;
  }
}
