import 'dart:async';

import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:cooker_app/src/core/helper/date_helper.dart';
import 'package:cooker_app/src/core/helper/price_helper.dart';
import 'package:cooker_app/src/core/helper/responsive_helper.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';
import 'package:cooker_app/src/features/order/presentation/provider/filter_provider.dart';
import 'package:cooker_app/src/features/status/data/model/status_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../cart/model/cart_model.dart';
import '../../../category/model/category_model.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../customer/presentation/provider/customer_provider.dart';
import '../../../product/data/model/product_model.dart';
import '../../../product/presentation/provider/product_provider.dart';
import '../../../status/presentation/provider/status_provider.dart';
import '../provider/order_provider.dart';
import '../provider/sort_provider.dart';

enum TableEnum {
  orders,
  /*products,
  customers,
  categories,*/
  cart,
}

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

    SortProvider sortProvider = context.read<SortProvider>();
    FilterProvider filterProvider = context.read<FilterProvider>();

    // add listener to sortProvider
    sortProvider.addListener(() {
      print('sortProvider.sortType');
      setState(() {
        bool isAscending = sortProvider.isAscending;
        if (isAscending) {
          switch (filterProvider.selectedFilterType) {
            case FilterType.hour:
              orders.sort((a, b) => a.time.hour.compareTo(b.time.hour));
              break;
            /*case FilterType.product:
              orders.sort((a, b) => a.cart.length.compareTo(b.cart.length));
              break;*/
            /*case FilterType.category:
              orders.sort((a, b) => a.cart.length.compareTo(b.cart.length));
              break;*/
            case FilterType.customer:
              orders.sort((a, b) => a.customer.fName.compareTo(b.customer.fName));
              break;
            default:
              orders.sort((a, b) => a.time.hour.compareTo(b.time.hour));
          }
        } else {
          switch (filterProvider.selectedFilterType) {
            case FilterType.status:
            case FilterType.hour:
              orders.sort((a, b) => b.time.hour.compareTo(a.time.hour));
              break;
            /* case FilterType.product:
              orders.sort((a, b) => b.cart.length.compareTo(a.cart.length));
              break;*/
            /*case FilterType.category:
              orders.sort((a, b) => b.cart.length.compareTo(a.cart.length));
              break;*/
            case FilterType.customer:
              orders.sort((a, b) => b.customer.fName.compareTo(a.customer.fName));
              break;
            default:
              orders.sort((a, b) => b.time.hour.compareTo(a.time.hour));
          }
        }
      });
    });

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

              /*if (payload.eventType == PostgresChangeEvent.insert) {
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
              }*/
              TableEnum tableEnum = TableEnum.values.firstWhere((element) => element.toString().split('.').last == payload.table);
              print('tableEnum');
              print(tableEnum);

              if (DateTime.parse(payload.newRecord['date']) == widget.selectedDate) {
                switch (tableEnum) {
                  case TableEnum.orders:
                    print('orders case');
                    print(tableEnum);

                    switch (payload.eventType) {
                      case PostgresChangeEvent.insert:
                        try {
                          print('case PostgresChangeEvent.insert on orders');
                          int orderId = payload.newRecord['id'];
                          DateTime orderDate = DateTime.parse(payload.newRecord['date']);
                          material.TimeOfDay orderTime = material.TimeOfDay(hour: int.parse(payload.newRecord['time'].split(':')[0]), minute: int.parse(payload.newRecord['time'].split(':')[1]));
                          DateTime createdAt = DateTime.parse(payload.newRecord['created_at']);

                          int statusId = payload.newRecord['status_id'];
                          List<StatusModel> statusList = context.read<StatusProvider>().statusList;
                          StatusModel status = statusList.firstWhere((element) => element.id == statusId);

                          int customerId = payload.newRecord['customer_id'];
                          List<CustomerModel> customerList = context.read<CustomerProvider>().customerList;
                          CustomerModel customer = customerList.firstWhere((element) => element.id == customerId);

                          OrderModel newOrder = OrderModel(id: orderId, createdAt: createdAt, updatedAt: createdAt, cookingStartedAt: null, readyAt: null, collectedAt: null, date: orderDate, time: orderTime, customer: customer, status: status, user: null, cart: [], nbTotalItemsCart: 0);
                          print('newOrder');
                          print(newOrder.toJson());
                          setState(() {
                            orders.add(newOrder);
                            pendingOrders = orders.where((element) => element.status.name == 'pending').toList();

                            nbOrders[0] = orders.length;
                            nbOrders[1] = pendingOrders.length;
                          });
                        } catch (e) {
                          print('error');
                          print(e);
                        }

                        break;
                      default:
                        break;
                    }
                    break;

                  case TableEnum.cart:
                    print('cart case');
                    print(tableEnum);
                    switch (payload.eventType) {
                      case PostgresChangeEvent.insert:
                        try {
                          print('case PostgresChangeEvent.insert on cart');
                          print('payload.newRecord');
                          print(payload.newRecord);
                          int orderId = payload.newRecord['id'];
                          ProductModel product = context.read<ProductProvider>().productList.firstWhere((element) => element.id == payload.newRecord['product_id']);
                          CartModel cart = CartModel.fromJson(payload.newRecord, isFromTable: true, orderId: orderId, orderDate: DateTime.parse(payload.newRecord['date']), product: product);
                          print('cart');
                          print(cart.toJson());
                          OrderModel order = orders.firstWhere((element) => element.id == orderId);
                          setState(() {
                            order.cart.add(cart);
                            order.totalAmount = order.cart.fold(0, (previousValue, element) => previousValue + (element.product.price * element.quantity));
                            order.nbTotalItemsCart = order.cart.fold(0, (previousValue, element) => previousValue + element.quantity);
                          });
                        } catch (e) {
                          print('error');
                          print(e);
                        }

                        break;
                      default:
                        break;
                    }
                    break;
                  default:
                    break;
                }
              }
            })
        .subscribe();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProductProvider>().initProductList();

      context.read<StatusProvider>().getAllStatus();
      context.read<CustomerProvider>().initCustomerList();
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
    return material.Scaffold(
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
          title: !ResponsiveHelper.isDesktop(context)
              ? DateBar(
                  selectedDate: widget.selectedDate,
                )
              : Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: context.watch<FilterProvider>().selectedFilterType == FilterType.status
                            ? StatusBar(nbOrders: nbOrders)
                            : context.watch<FilterProvider>().selectedFilterType == FilterType.hour
                                ? HourBar(lstOrder: orders)
                                : context.watch<FilterProvider>().selectedFilterType == FilterType.product
                                    ? ProductBar(lstOrder: orders)
                                    : context.watch<FilterProvider>().selectedFilterType == FilterType.category
                                        ? CategoryBar(lstOrder: orders)
                                        : context.watch<FilterProvider>().selectedFilterType == FilterType.customer
                                            ? CustomerBar(lstOrder: orders)
                                            : Container(),
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
                                    material.BackButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Filter and Sort',
                                          style: FluentTheme.of(context).typography.bodyLarge!.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Expanded(
                                  child: ListView(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Filter',
                                      style: FluentTheme.of(context).typography.bodyLarge!.copyWith(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),

                                  Card(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(0),
                                    child: ListTile.selectable(
                                      onPressed: () {
                                        context.read<FilterProvider>().setSelectedFilterType(FilterType.status);
                                      },
                                      selected: context.watch<FilterProvider>().selectedFilterType == FilterType.status,
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          FluentIcons.status_circle_block,
                                          size: 40,
                                        ),
                                      ),
                                      title: Text('Filter by Status', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                      trailing: RadioButton(
                                        checked: context.watch<FilterProvider>().selectedFilterType == FilterType.status,
                                        onChanged: (value) {
                                          context.read<FilterProvider>().setSelectedFilterType(FilterType.status);
                                        },
                                      ),
                                    ),
                                  ),

                                  Card(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(0),
                                    child: ListTile.selectable(
                                      onPressed: () {
                                        context.read<FilterProvider>().setSelectedFilterType(FilterType.hour);
                                      },
                                      selected: context.watch<FilterProvider>().selectedFilterType == FilterType.hour,
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          FluentIcons.clock,
                                          size: 40,
                                        ),
                                      ),
                                      title: Text('Filter by Hour', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                      trailing: RadioButton(
                                        checked: context.watch<FilterProvider>().selectedFilterType == FilterType.hour,
                                        onChanged: (value) {
                                          context.read<FilterProvider>().setSelectedFilterType(FilterType.hour);
                                        },
                                      ),
                                    ),
                                  ),
                                  Card(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(0),
                                    child: ListTile.selectable(
                                      onPressed: () {
                                        context.read<FilterProvider>().setSelectedFilterType(FilterType.product);
                                      },
                                      selected: context.watch<FilterProvider>().selectedFilterType == FilterType.product,
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          FluentIcons.product_catalog,
                                          size: 40,
                                        ),
                                      ),
                                      title: Text('Filter by Product', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                      trailing: RadioButton(
                                        checked: context.watch<FilterProvider>().selectedFilterType == FilterType.product,
                                        onChanged: (value) {
                                          context.read<FilterProvider>().setSelectedFilterType(FilterType.product);
                                        },
                                      ),
                                    ),
                                  ),
                                  Card(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(0),
                                    child: ListTile.selectable(
                                      onPressed: () {
                                        context.read<FilterProvider>().setSelectedFilterType(FilterType.category);
                                      },
                                      selected: context.watch<FilterProvider>().selectedFilterType == FilterType.category,
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          FluentIcons.product_catalog,
                                          size: 40,
                                        ),
                                      ),
                                      title: Text('Filter by Category', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                      trailing: RadioButton(
                                        checked: context.watch<FilterProvider>().selectedFilterType == FilterType.category,
                                        onChanged: (value) {
                                          context.read<FilterProvider>().setSelectedFilterType(FilterType.category);
                                        },
                                      ),
                                    ),
                                  ),
                                  Card(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(0),
                                    child: ListTile.selectable(
                                      onPressed: () {
                                        context.read<FilterProvider>().setSelectedFilterType(FilterType.customer);
                                      },
                                      selected: context.watch<FilterProvider>().selectedFilterType == FilterType.customer,
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          FluentIcons.contact,
                                          size: 40,
                                        ),
                                      ),
                                      title: Text('Filter by Customer', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                      trailing: RadioButton(
                                        checked: context.watch<FilterProvider>().selectedFilterType == FilterType.customer,
                                        onChanged: (value) {
                                          context.read<FilterProvider>().setSelectedFilterType(FilterType.customer);
                                        },
                                      ),
                                    ),
                                  ),

                                  // sort title
                                  if (context.watch<FilterProvider>().selectedFilterType != FilterType.status)
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Sort',
                                        style: FluentTheme.of(context).typography.bodyLarge!.copyWith(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  if (context.watch<FilterProvider>().selectedFilterType != FilterType.status)
                                    Card(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(0),
                                      child: ListTile.selectable(
                                        onPressed: () {
                                          context.read<SortProvider>().setAscending(true);
                                        },
                                        selected: context.watch<SortProvider>().isAscending,
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            FluentIcons.sort_up,
                                            size: 40,
                                          ),
                                        ),
                                        title: Text('Ascending', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                        trailing: RadioButton(
                                          checked: context.watch<SortProvider>().isAscending,
                                          onChanged: (value) {
                                            context.read<SortProvider>().setAscending(true);
                                          },
                                        ),
                                      ),
                                    ),
                                  if (context.watch<FilterProvider>().selectedFilterType != FilterType.status)
                                    Card(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(0),
                                      child: ListTile.selectable(
                                        onPressed: () {
                                          context.read<SortProvider>().setAscending(false);
                                        },
                                        selected: !context.watch<SortProvider>().isAscending,
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            FluentIcons.sort_down,
                                            size: 40,
                                          ),
                                        ),
                                        title: Text('Descending', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                                        trailing: RadioButton(
                                          checked: !context.watch<SortProvider>().isAscending,
                                          onChanged: (value) {
                                            context.read<SortProvider>().setAscending(false);
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              )),
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
                                    child: context.watch<FilterProvider>().selectedFilterType == FilterType.status
                                        ? StatusBar(nbOrders: nbOrders)
                                        : context.watch<FilterProvider>().selectedFilterType == FilterType.hour
                                            ? HourBar(lstOrder: orders)
                                            : context.watch<FilterProvider>().selectedFilterType == FilterType.product
                                                ? ProductBar(lstOrder: orders)
                                                : context.watch<FilterProvider>().selectedFilterType == FilterType.category
                                                    ? CategoryBar(lstOrder: orders)
                                                    : context.watch<FilterProvider>().selectedFilterType == FilterType.customer
                                                        ? CustomerBar(lstOrder: orders)
                                                        : Container(),
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
                          child: context.watch<FilterProvider>().selectedFilterType == FilterType.product
                              ? ProductItemListWidget(lstOrder: orders)
                              : context.watch<FilterProvider>().selectedFilterType == FilterType.hour
                                  ? HourItemListWidget(
                                      lstOrder: context.watch<FilterProvider>().selectedHour == null
                                          ? orders
                                          : orders.where((element) {
                                              return element.time.hour == context.watch<FilterProvider>().selectedHour?.hour;
                                            }).toList())
                                  : context.watch<FilterProvider>().selectedFilterType == FilterType.category
                                      ? CategoryItemListWidget(
                                          lstOrder: context.watch<FilterProvider>().selectedCategoryId == null
                                              ? orders
                                              : orders.where((element) {
                                                  return element.cart.any((element) => element.product.category!.id == context.watch<FilterProvider>().selectedCategoryId);
                                                }).toList())
                                      : context.watch<FilterProvider>().selectedFilterType == FilterType.customer
                                          ? CustomerItemListWidget(
                                              lstOrder: context.watch<FilterProvider>().selectedCustomerId == null
                                                  ? orders
                                                  : orders.where((element) {
                                                      return element.customer.id! == context.watch<FilterProvider>().selectedCustomerId;
                                                    }).toList())
                                          : Column(
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

class ProductItemListWidget extends StatefulWidget {
  final List<OrderModel> lstOrder;
  const ProductItemListWidget({super.key, required this.lstOrder});

  @override
  State<ProductItemListWidget> createState() => _ProductItemListWidgetState();
}

class _ProductItemListWidgetState extends State<ProductItemListWidget> {
  List<ProductModel> allProductOfTheDay = [];

  @override
  void initState() {
    super.initState();
    List<ProductModel> allProductOfTheDayTemp = [];
    List<int> allProductOfTheDayTempId = [];
    for (var order in widget.lstOrder) {
      for (var cart in order.cart) {
        if (!allProductOfTheDayTempId.contains(cart.product.id)) {
          allProductOfTheDayTempId.add(cart.product.id);
          allProductOfTheDayTemp.add(cart.product);
        }
      }
    }
    setState(() {
      allProductOfTheDay = allProductOfTheDayTemp;
    });
  }

  @override
  void didUpdateWidget(covariant ProductItemListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
    List<ProductModel> allProductOfTheDayTemp = [];
    List<int> allProductOfTheDayTempId = [];
    for (var order in widget.lstOrder) {
      for (var cart in order.cart) {
        if (!allProductOfTheDayTempId.contains(cart.product.id)) {
          allProductOfTheDayTempId.add(cart.product.id);
          allProductOfTheDayTemp.add(cart.product);
        }
      }
    }
    // if ascending sort
    if (context.read<SortProvider>().isAscending) {
      allProductOfTheDayTemp.sort((a, b) => a.name.compareTo(b.name));
    } else {
      allProductOfTheDayTemp.sort((a, b) => b.name.compareTo(a.name));
    }
    setState(() {
      allProductOfTheDay = allProductOfTheDayTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        allProductOfTheDay.length,
        (index) {
          List<CartModel> lstCart = [];
          for (var order in widget.lstOrder) {
            for (var cart in order.cart) {
              if (cart.product.id == allProductOfTheDay[index].id) {
                lstCart.add(cart);
              }
            }
          }
          print(allProductOfTheDay[index].id);
          if (context.watch<FilterProvider>().selectedProductId != null && context.watch<FilterProvider>().selectedProductId != allProductOfTheDay[index].id) {
            return Container();
          }
          return Container(
            margin: const EdgeInsets.all(10),
            child: ProductItemWidget(product: allProductOfTheDay[index], lstCart: lstCart),
          );
        },
      ),
    );
  }
}

class ProductItemWidget extends StatefulWidget {
  final ProductModel product;
  final List<CartModel> lstCart;
  const ProductItemWidget({super.key, required this.product, required this.lstCart});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Expander(
      initiallyExpanded: true,
      header: Text('${widget.product.name} (${widget.lstCart.fold(0, (previousValue, element) => previousValue + element.quantity)})'),
      content: Column(
        children: List.generate(
          widget.lstCart.length,
          (index) {
            return Card(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(0),
              child: ListTile(
                onPressed: () {
                  String id = widget.lstCart[index].orderId.toString();
                  String date = DateHelper.getFormattedDate(widget.lstCart[index].orderDate);
                  context.go('/orders/$date/$id');
                },
                leading: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text('#${widget.lstCart[index].orderId}', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    if (widget.lstCart[index].product.photoUrl != null && widget.lstCart[index].product.photoUrl!.isNotEmpty)
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.network(
                          widget.lstCart[index].product.photoUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              FluentIcons.image_pixel,
                              size: 50,
                              color: Colors.red,
                            );
                          },
                        ),
                      ),
                  ],
                ),
                title: Text(widget.lstCart[index].product.name),
                subtitle: Text('Quantity: ${widget.lstCart[index].quantity}'),
                trailing: Row(
                  children: [
                    /*Text(
                      PriceHelper.getFormattedPrice(widget.lstCart[index].product.price * widget.lstCart[index].quantity),
                    ),*/
                    if (widget.lstCart[index].isDone)
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          FluentIcons.skype_circle_check,
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Icon(FluentIcons.chevron_right_small, size: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HourBar extends StatefulWidget {
  final List<OrderModel> lstOrder;
  const HourBar({super.key, required this.lstOrder});

  @override
  State<HourBar> createState() => _HourBarState();
}

class _HourBarState extends State<HourBar> {
  List<material.TimeOfDay> lstHour = [];

  @override
  void initState() {
    super.initState();
    List<material.TimeOfDay> lstHourTemp = [];
    print('widget.lstOrder');
    print(widget.lstOrder.length);
    for (var order in widget.lstOrder) {
      material.TimeOfDay time = material.TimeOfDay(hour: order.time.hour, minute: 0);
      print('time');
      print(time);
      if (!lstHourTemp.contains(time)) {
        lstHourTemp.add(time);
      }
    }
    setState(() {
      lstHour = lstHourTemp;
    });
  }

  @override
  void didUpdateWidget(covariant HourBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    List<material.TimeOfDay> lstHourTemp = [];
    for (var order in widget.lstOrder) {
      material.TimeOfDay time = material.TimeOfDay(hour: order.time.hour, minute: 0);
      if (!lstHourTemp.contains(time)) {
        lstHourTemp.add(time);
      }
    }
    setState(() {
      lstHour = lstHourTemp;
    });
  }

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
      child: ListView.builder(
        itemCount: lstHour.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: const EdgeInsets.all(5),
              child: Button(
                  style: ButtonStyle(
                    elevation: ButtonState.all(context.watch<FilterProvider>().selectedHour == null ? 2 : 0),
                    shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!, width: 1))),
                    padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                    backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedHour == null ? FluentTheme.of(context).navigationPaneTheme.backgroundColor : null),
                  ),
                  child: Text('All (${widget.lstOrder.length})'),
                  onPressed: () {
                    context.read<FilterProvider>().setSelectedHour(null);
                  }),
            );
          }
          return Container(
            padding: const EdgeInsets.all(5),
            child: Button(
                style: ButtonStyle(
                  elevation: ButtonState.all(context.watch<FilterProvider>().selectedHour == lstHour[index - 1] ? 2 : 0),
                  shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!, width: 1))),
                  padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                  backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedHour == lstHour[index - 1] ? FluentTheme.of(context).navigationPaneTheme.backgroundColor : null),
                ),
                child: Text('${lstHour[index - 1].format(context)} (${widget.lstOrder.where((element) => element.time.hour == lstHour[index - 1].hour).length})'),
                onPressed: () {
                  context.read<FilterProvider>().setSelectedHour(lstHour[index - 1]);
                }),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class HourItemWidget extends StatefulWidget {
  final material.TimeOfDay time;
  final List<OrderModel> lstOrder;
  const HourItemWidget({super.key, required this.time, required this.lstOrder});

  @override
  State<HourItemWidget> createState() => _HourItemWidgetState();
}

class _HourItemWidgetState extends State<HourItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: List.generate(
          widget.lstOrder.length,
          (index) {
            return Card(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(0),
              child: ListTile(
                onPressed: () {
                  String id = widget.lstOrder[index].id.toString();
                  String date = DateHelper.getFormattedDate(widget.lstOrder[index].date);
                  context.go('/orders/$date/$id');
                },
                leading: Container(
                  height: 50,
                  width: 50,
                  child: Icon(
                    FluentIcons.clock,
                    size: 40,
                  ),
                ),
                title: Text('Order #${widget.lstOrder[index].id}'),
                subtitle: Text('Time: ${widget.lstOrder[index].time.format(context)}'),
                trailing: Row(
                  children: [
                    Text(
                      PriceHelper.getFormattedPrice(widget.lstOrder[index].totalAmount),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Icon(FluentIcons.chevron_right_small, size: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HourItemListWidget extends StatefulWidget {
  final List<OrderModel> lstOrder;
  const HourItemListWidget({super.key, required this.lstOrder});

  @override
  State<HourItemListWidget> createState() => _HourItemListWidgetState();
}

class _HourItemListWidgetState extends State<HourItemListWidget> {
  List<material.TimeOfDay> lstHour = [];

  @override
  void initState() {
    super.initState();
    List<material.TimeOfDay> lstHourTemp = [];
    for (var order in widget.lstOrder) {
      material.TimeOfDay time = material.TimeOfDay(hour: order.time.hour, minute: 0);
      if (!lstHourTemp.contains(time)) {
        lstHourTemp.add(time);
      }
    }
    setState(() {
      lstHour = lstHourTemp;
    });
  }

  @override
  void didUpdateWidget(covariant HourItemListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    List<material.TimeOfDay> lstHourTemp = [];
    for (var order in widget.lstOrder) {
      material.TimeOfDay time = material.TimeOfDay(hour: order.time.hour, minute: 0);
      if (!lstHourTemp.contains(time)) {
        lstHourTemp.add(time);
      }
    }
    setState(() {
      lstHour = lstHourTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        lstHour.length,
        (index) {
          List<OrderModel> lstOrder = [];
          for (var order in widget.lstOrder) {
            if (order.time.hour == lstHour[index].hour) {
              lstOrder.add(order);
            }
          }
          if (lstOrder.isEmpty) {
            return Container();
          }
          return Container(
            margin: const EdgeInsets.all(10),
            child: Expander(
              initiallyExpanded: true,
              header: Text('${lstHour[index].format(context)} (${lstOrder.length})'),
              content: Column(
                children: List.generate(
                  lstOrder.length,
                  (index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(0),
                      child: ListTile(
                        onPressed: () {
                          String id = lstOrder[index].id.toString();
                          String date = DateHelper.getFormattedDate(lstOrder[index].date);
                          context.go('/orders/$date/$id');
                        },
                        leading: Container(
                          height: 50,
                          width: 50,
                          child: Icon(
                            FluentIcons.clock,
                            size: 40,
                          ),
                        ),
                        title: Text('Order #${lstOrder[index].id}'),
                        subtitle: Text('Time: ${lstOrder[index].time.format(context)}'),
                        trailing: Row(
                          children: [
                            Text(
                              PriceHelper.getFormattedPrice(lstOrder[index].totalAmount),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Icon(FluentIcons.chevron_right_small, size: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductBar extends StatefulWidget {
  final List<OrderModel> lstOrder;
  const ProductBar({super.key, required this.lstOrder});

  @override
  State<ProductBar> createState() => _ProductBarState();
}

class _ProductBarState extends State<ProductBar> {
  List<Map<int, List<CartModel>>> lstCartModelByProductId = [];

  @override
  void initState() {
    super.initState();
    List<Map<int, List<CartModel>>> lstCartModelByProductIdTemp = [];
    for (var order in widget.lstOrder) {
      for (var cart in order.cart) {
        if (lstCartModelByProductIdTemp.isEmpty) {
          lstCartModelByProductIdTemp.add({
            cart.product.id: [cart]
          });
        } else {
          bool isExist = false;
          for (var cartModel in lstCartModelByProductIdTemp) {
            if (cartModel.containsKey(cart.product.id)) {
              isExist = true;
              cartModel[cart.product.id]!.add(cart);
            }
          }
          if (!isExist) {
            lstCartModelByProductIdTemp.add({
              cart.product.id: [cart]
            });
          }
        }
      }
    }
    setState(() {
      lstCartModelByProductId = lstCartModelByProductIdTemp;
    });
  }

  @override
  void didUpdateWidget(covariant ProductBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    List<Map<int, List<CartModel>>> lstCartModelByProductIdTemp = [];
    for (var order in widget.lstOrder) {
      for (var cart in order.cart) {
        if (lstCartModelByProductIdTemp.isEmpty) {
          lstCartModelByProductIdTemp.add({
            cart.product.id: [cart]
          });
        } else {
          bool isExist = false;
          for (var cartModel in lstCartModelByProductIdTemp) {
            if (cartModel.containsKey(cart.product.id)) {
              isExist = true;
              cartModel[cart.product.id]!.add(cart);
            }
          }
          if (!isExist) {
            lstCartModelByProductIdTemp.add({
              cart.product.id: [cart]
            });
          }
        }
      }
    }
    // if ascending sort
    if (context.read<SortProvider>().isAscending) {
      lstCartModelByProductIdTemp.sort((a, b) => a.values.first.first.product.name.compareTo(b.values.first.first.product.name));
    } else {
      lstCartModelByProductIdTemp.sort((a, b) => b.values.first.first.product.name.compareTo(a.values.first.first.product.name));
    }
    setState(() {
      lstCartModelByProductId = lstCartModelByProductIdTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: !ResponsiveHelper.isDesktop(context) ? FluentTheme.of(context).cardColor : null,
      ),
      child: ListView.builder(
        itemCount: lstCartModelByProductId.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            int totalProduct = widget.lstOrder.fold(0, (previousValue, element) => previousValue + element.cart.fold(0, (previousValue, element) => previousValue + element.quantity));
            return Container(
              padding: const EdgeInsets.all(5),
              child: Button(
                  style: ButtonStyle(
                    elevation: ButtonState.all(context.watch<FilterProvider>().selectedProductId == null ? 2 : 0),
                    shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!, width: 1))),
                    padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                    backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedProductId == null ? FluentTheme.of(context).navigationPaneTheme.backgroundColor : null),
                  ),
                  child: Text('All (${totalProduct})'),
                  onPressed: () {
                    context.read<FilterProvider>().setSelectedProductId(null);
                  }),
            );
          } else {
            int totalProduct = lstCartModelByProductId[index - 1].values.first.fold(0, (previousValue, element) => previousValue + element.quantity);
            return Container(
              padding: const EdgeInsets.all(5),
              child: Button(
                  style: ButtonStyle(
                    elevation: ButtonState.all(context.watch<FilterProvider>().selectedProductId == lstCartModelByProductId[index - 1].keys.first ? 2 : 0),
                    shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!, width: 1))),
                    padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                    backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedProductId == lstCartModelByProductId[index - 1].keys.first ? FluentTheme.of(context).navigationPaneTheme.backgroundColor : null),
                  ),
                  child: Text('${lstCartModelByProductId[index - 1].values.first.first.product.name} (${totalProduct})'),
                  onPressed: () {
                    context.read<FilterProvider>().setSelectedProductId(lstCartModelByProductId[index - 1].keys.first);
                  }),
            );
          }
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class CategoryBar extends StatefulWidget {
  final List<OrderModel> lstOrder;
  const CategoryBar({super.key, required this.lstOrder});

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  List<Map<int, List<CartModel>>> lstCartModelByCategoryId = [];

  @override
  void initState() {
    super.initState();
    List<Map<int, List<CartModel>>> lstCartModelByCategoryIdTemp = [];
    for (var order in widget.lstOrder) {
      for (var cart in order.cart) {
        if (lstCartModelByCategoryIdTemp.isEmpty) {
          lstCartModelByCategoryIdTemp.add({
            cart.product.category!.id: [cart]
          });
        } else {
          bool isExist = false;
          for (var cartModel in lstCartModelByCategoryIdTemp) {
            if (cartModel.containsKey(cart.product.category!.id)) {
              isExist = true;
              cartModel[cart.product.category!.id]!.add(cart);
            }
          }
          if (!isExist) {
            lstCartModelByCategoryIdTemp.add({
              cart.product.category!.id: [cart]
            });
          }
        }
      }
    }
    setState(() {
      lstCartModelByCategoryId = lstCartModelByCategoryIdTemp;
    });
  }

  @override
  void didUpdateWidget(covariant CategoryBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    List<Map<int, List<CartModel>>> lstCartModelByCategoryIdTemp = [];
    for (var order in widget.lstOrder) {
      for (var cart in order.cart) {
        if (lstCartModelByCategoryIdTemp.isEmpty) {
          lstCartModelByCategoryIdTemp.add({
            cart.product.category!.id: [cart]
          });
        } else {
          bool isExist = false;
          for (var cartModel in lstCartModelByCategoryIdTemp) {
            if (cartModel.containsKey(cart.product.category!.id)) {
              isExist = true;
              cartModel[cart.product.category!.id]!.add(cart);
            }
          }
          if (!isExist) {
            lstCartModelByCategoryIdTemp.add({
              cart.product.category!.id: [cart]
            });
          }
        }
      }
    }
    // if ascending sort
    if (context.read<SortProvider>().isAscending) {
      lstCartModelByCategoryIdTemp.sort((a, b) => a.values.first.first.product.category!.name.compareTo(b.values.first.first.product.category!.name));
    } else {
      lstCartModelByCategoryIdTemp.sort((a, b) => b.values.first.first.product.category!.name.compareTo(a.values.first.first.product.category!.name));
    }
    setState(() {
      lstCartModelByCategoryId = lstCartModelByCategoryIdTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: !ResponsiveHelper.isDesktop(context) ? FluentTheme.of(context).cardColor : null,
      ),
      child: ListView.builder(
        itemCount: lstCartModelByCategoryId.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            int totalProduct = widget.lstOrder.fold(0, (previousValue, element) => previousValue + element.cart.fold(0, (previousValue, element) => previousValue + element.quantity));
            return Container(
              padding: const EdgeInsets.all(5),
              child: Button(
                  style: ButtonStyle(
                    elevation: ButtonState.all(context.watch<FilterProvider>().selectedCategoryId == null ? 2 : 0),
                    shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!, width: 1))),
                    padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                    backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedCategoryId == null ? FluentTheme.of(context).navigationPaneTheme.backgroundColor : null),
                  ),
                  child: Text('All (${totalProduct})'),
                  onPressed: () {
                    context.read<FilterProvider>().setSelectedCategoryId(null);
                  }),
            );
          } else {
            int totalProduct = lstCartModelByCategoryId[index - 1].values.first.fold(0, (previousValue, element) => previousValue + element.quantity);
            return Container(
              padding: const EdgeInsets.all(5),
              child: Button(
                  style: ButtonStyle(
                    elevation: ButtonState.all(context.watch<FilterProvider>().selectedCategoryId == lstCartModelByCategoryId[index - 1].keys.first ? 2 : 0),
                    shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!, width: 1))),
                    padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                    backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedCategoryId == lstCartModelByCategoryId[index - 1].keys.first ? FluentTheme.of(context).navigationPaneTheme.backgroundColor : null),
                  ),
                  child: Text('${lstCartModelByCategoryId[index - 1].values.first.first.product.category!.name} (${totalProduct})'),
                  onPressed: () {
                    context.read<FilterProvider>().setSelectedCategoryId(lstCartModelByCategoryId[index - 1].keys.first);
                  }),
            );
          }
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class CategoryItemWidget extends StatefulWidget {
  final CategoryModel category;
  final List<CartModel> lstCart;
  const CategoryItemWidget({super.key, required this.category, required this.lstCart});

  @override
  State<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Expander(
      initiallyExpanded: true,
      header: Text('${widget.category.name} (${widget.lstCart.fold(0, (previousValue, element) => previousValue + element.quantity)})'),
      content: Column(
        children: List.generate(
          widget.lstCart.length,
          (index) {
            return Card(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(0),
              child: ListTile(
                onPressed: () {
                  String id = widget.lstCart[index].orderId.toString();
                  String date = DateHelper.getFormattedDate(widget.lstCart[index].orderDate);
                  context.go('/orders/$date/$id');
                },
                leading: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text('#${widget.lstCart[index].orderId}', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: Image.network(
                        widget.lstCart[index].product.photoUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            FluentIcons.image_pixel,
                            size: 50,
                            color: Colors.red,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                title: Text(widget.lstCart[index].product.name),
                subtitle: Text('Quantity: ${widget.lstCart[index].quantity}'),
                trailing: Row(
                  children: [
                    Text(
                      PriceHelper.getFormattedPrice(widget.lstCart[index].product.price * widget.lstCart[index].quantity),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Icon(FluentIcons.chevron_right_small, size: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryItemListWidget extends StatefulWidget {
  final List<OrderModel> lstOrder;
  const CategoryItemListWidget({super.key, required this.lstOrder});

  @override
  State<CategoryItemListWidget> createState() => _CategoryItemListWidgetState();
}

class _CategoryItemListWidgetState extends State<CategoryItemListWidget> {
  List<CategoryModel> allCategoryOfTheDay = [];

  @override
  void initState() {
    super.initState();
    List<CategoryModel> allCategoryOfTheDayTemp = [];
    List<int> allCategoryOfTheDayTempId = [];
    for (var order in widget.lstOrder) {
      for (var cart in order.cart) {
        if (!allCategoryOfTheDayTempId.contains(cart.product.category!.id)) {
          allCategoryOfTheDayTempId.add(cart.product.category!.id!);
          allCategoryOfTheDayTemp.add(cart.product.category!);
        }
      }
    }

    print('allCategoryOfTheDayTemp');
    print(allCategoryOfTheDayTemp.length);
    setState(() {
      allCategoryOfTheDay = allCategoryOfTheDayTemp;
    });
  }

  @override
  void didUpdateWidget(covariant CategoryItemListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    List<CategoryModel> allCategoryOfTheDayTemp = [];
    List<int> allCategoryOfTheDayTempId = [];
    for (var order in widget.lstOrder) {
      for (var cart in order.cart) {
        if (!allCategoryOfTheDayTempId.contains(cart.product.category!.id)) {
          allCategoryOfTheDayTempId.add(cart.product.category!.id!);
          allCategoryOfTheDayTemp.add(cart.product.category!);
        }
      }
    }
    // if ascending sort
    if (context.read<SortProvider>().isAscending) {
      allCategoryOfTheDayTemp.sort((a, b) => a.name.compareTo(b.name));
    } else {
      allCategoryOfTheDayTemp.sort((a, b) => b.name.compareTo(a.name));
    }
    setState(() {
      allCategoryOfTheDay = allCategoryOfTheDayTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        allCategoryOfTheDay.length,
        (index) {
          List<CartModel> lstCart = [];
          for (var order in widget.lstOrder) {
            for (var cart in order.cart) {
              if (cart.product.category!.id! == allCategoryOfTheDay[index].id) {
                lstCart.add(cart);
              }
            }
          }
          if (lstCart.isEmpty) {
            return Container();
          }
          return Container(
            margin: const EdgeInsets.all(10),
            child: CategoryItemWidget(category: allCategoryOfTheDay[index], lstCart: lstCart),
          );
        },
      ),
    );
  }
}

class CustomerBar extends StatefulWidget {
  final List<OrderModel> lstOrder;
  const CustomerBar({super.key, required this.lstOrder});

  @override
  State<CustomerBar> createState() => _CustomerBarState();
}

class _CustomerBarState extends State<CustomerBar> {
  List<Map<int, List<OrderModel>>> lstOrderModelByCustomerId = [];

  @override
  void initState() {
    super.initState();
    List<Map<int, List<OrderModel>>> lstOrderModelByCustomerIdTemp = [];
    for (var order in widget.lstOrder) {
      if (lstOrderModelByCustomerIdTemp.isEmpty) {
        lstOrderModelByCustomerIdTemp.add({
          order.customer!.id!: [order]
        });
      } else {
        bool isExist = false;
        for (var orderModel in lstOrderModelByCustomerIdTemp) {
          if (orderModel.containsKey(order.customer!.id)) {
            isExist = true;
            orderModel[order.customer!.id]!.add(order);
          }
        }
        if (!isExist) {
          lstOrderModelByCustomerIdTemp.add({
            order.customer!.id!: [order]
          });
        }
      }
    }
    // if ascending sort
    if (context.read<SortProvider>().isAscending) {
      lstOrderModelByCustomerIdTemp.sort((a, b) => a.values.first.first.customer!.fName.compareTo(b.values.first.first.customer!.fName));
    } else {
      lstOrderModelByCustomerIdTemp.sort((a, b) => b.values.first.first.customer!.fName.compareTo(a.values.first.first.customer!.fName));
    }
    setState(() {
      lstOrderModelByCustomerId = lstOrderModelByCustomerIdTemp;
    });
  }

  @override
  void didUpdateWidget(covariant CustomerBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    List<Map<int, List<OrderModel>>> lstOrderModelByCustomerIdTemp = [];
    for (var order in widget.lstOrder) {
      if (lstOrderModelByCustomerIdTemp.isEmpty) {
        lstOrderModelByCustomerIdTemp.add({
          order.customer!.id!: [order]
        });
      } else {
        bool isExist = false;
        for (var orderModel in lstOrderModelByCustomerIdTemp) {
          if (orderModel.containsKey(order.customer!.id)) {
            isExist = true;
            orderModel[order.customer!.id]!.add(order);
          }
        }
        if (!isExist) {
          lstOrderModelByCustomerIdTemp.add({
            order.customer!.id!: [order]
          });
        }
      }
    }
    // if ascending sort
    if (context.read<SortProvider>().isAscending) {
      lstOrderModelByCustomerIdTemp.sort((a, b) => a.values.first.first.customer!.fName.compareTo(b.values.first.first.customer!.fName));
    } else {
      lstOrderModelByCustomerIdTemp.sort((a, b) => b.values.first.first.customer!.fName.compareTo(a.values.first.first.customer!.fName));
    }
    setState(() {
      lstOrderModelByCustomerId = lstOrderModelByCustomerIdTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: !ResponsiveHelper.isDesktop(context) ? FluentTheme.of(context).cardColor : null,
      ),
      child: ListView.builder(
        itemCount: lstOrderModelByCustomerId.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: const EdgeInsets.all(5),
              child: Button(
                  style: ButtonStyle(
                    elevation: ButtonState.all(context.watch<FilterProvider>().selectedCustomerId == null ? 2 : 0),
                    shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!, width: 1))),
                    padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                    backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedCustomerId == null ? FluentTheme.of(context).navigationPaneTheme.backgroundColor : null),
                  ),
                  child: Text('All (${widget.lstOrder.length})'),
                  onPressed: () {
                    context.read<FilterProvider>().setSelectedCustomerId(null);
                  }),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(5),
              child: Button(
                  style: ButtonStyle(
                    elevation: ButtonState.all(context.watch<FilterProvider>().selectedCustomerId == lstOrderModelByCustomerId[index - 1].keys.first ? 2 : 0),
                    shape: ButtonState.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!, width: 1))),
                    padding: ButtonState.all(EdgeInsets.symmetric(vertical: 5, horizontal: 16)),
                    backgroundColor: ButtonState.all(context.watch<FilterProvider>().selectedCustomerId == lstOrderModelByCustomerId[index - 1].keys.first ? FluentTheme.of(context).navigationPaneTheme.backgroundColor : null),
                  ),
                  child: Text('${lstOrderModelByCustomerId[index - 1].values.first.first.customer!.fName} ${lstOrderModelByCustomerId[index - 1].values.first.first.customer!.lName} (${lstOrderModelByCustomerId[index - 1].values.length})'),
                  onPressed: () {
                    context.read<FilterProvider>().setSelectedCustomerId(lstOrderModelByCustomerId[index - 1].keys.first);
                  }),
            );
          }
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class CustomerItemWidget extends StatefulWidget {
  final CustomerModel customer;
  final List<OrderModel> lstOrder;
  const CustomerItemWidget({super.key, required this.customer, required this.lstOrder});

  @override
  State<CustomerItemWidget> createState() => _CustomerItemWidgetState();
}

class _CustomerItemWidgetState extends State<CustomerItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Expander(
      initiallyExpanded: true,
      header: Text('${widget.customer.fName} ${widget.customer.lName} (${widget.lstOrder.length})'),
      content: Column(
        children: List.generate(
          widget.lstOrder.length,
          (index) {
            return Card(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(0),
              child: ListTile(
                onPressed: () {
                  String id = widget.lstOrder[index].id.toString();
                  String date = DateHelper.getFormattedDate(widget.lstOrder[index].date);
                  context.go('/orders/$date/$id');
                },
                leading: Container(
                  height: 50,
                  width: 50,
                  child: Icon(
                    FluentIcons.contact,
                    size: 40,
                  ),
                ),
                title: Text('Order #${widget.lstOrder[index].id}'),
                subtitle: Text('Time: ${widget.lstOrder[index].time.format(context)}'),
                trailing: Row(
                  children: [
                    Text(
                      PriceHelper.getFormattedPrice(widget.lstOrder[index].totalAmount),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Icon(FluentIcons.chevron_right_small, size: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomerItemListWidget extends StatefulWidget {
  final List<OrderModel> lstOrder;
  const CustomerItemListWidget({super.key, required this.lstOrder});

  @override
  State<CustomerItemListWidget> createState() => _CustomerItemListWidgetState();
}

class _CustomerItemListWidgetState extends State<CustomerItemListWidget> {
  List<CustomerModel> allCustomerOfTheDay = [];

  @override
  void initState() {
    super.initState();
    List<CustomerModel> allCustomerOfTheDayTemp = [];
    List<int> allCustomerOfTheDayTempId = [];
    for (var order in widget.lstOrder) {
      if (!allCustomerOfTheDayTempId.contains(order.customer!.id)) {
        allCustomerOfTheDayTempId.add(order.customer!.id!);
        allCustomerOfTheDayTemp.add(order.customer!);
      }
    }

    print('allCustomerOfTheDayTemp');
    print(allCustomerOfTheDayTemp.length);

    if (context.read<SortProvider>().isAscending) {
      allCustomerOfTheDayTemp.sort((a, b) => a.fName.compareTo(b.fName));
    } else {
      allCustomerOfTheDayTemp.sort((a, b) => b.fName.compareTo(a.fName));
    }

    setState(() {
      allCustomerOfTheDay = allCustomerOfTheDayTemp;
    });
  }

  @override
  void didUpdateWidget(covariant CustomerItemListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    List<CustomerModel> allCustomerOfTheDayTemp = [];
    List<int> allCustomerOfTheDayTempId = [];
    for (var order in widget.lstOrder) {
      if (!allCustomerOfTheDayTempId.contains(order.customer!.id)) {
        allCustomerOfTheDayTempId.add(order.customer!.id!);
        allCustomerOfTheDayTemp.add(order.customer!);
      }
    }
    // if ascending sort
    if (context.read<SortProvider>().isAscending) {
      allCustomerOfTheDayTemp.sort((a, b) => a.fName.compareTo(b.fName));
    } else {
      allCustomerOfTheDayTemp.sort((a, b) => b.fName.compareTo(a.fName));
    }
    setState(() {
      allCustomerOfTheDay = allCustomerOfTheDayTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        allCustomerOfTheDay.length,
        (index) {
          List<OrderModel> lstOrder = [];
          for (var order in widget.lstOrder) {
            if (order.customer!.id! == allCustomerOfTheDay[index].id) {
              lstOrder.add(order);
            }
          }

          if (lstOrder.isEmpty) {
            return Container();
          }

          return Container(
            margin: const EdgeInsets.all(10),
            child: CustomerItemWidget(customer: allCustomerOfTheDay[index], lstOrder: lstOrder),
          );
        },
      ),
    );
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
