import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constant/app_text_style.dart';
import '../../../../core/helper/date_helper.dart';
import '../../../../core/helper/responsive_helper.dart';
import '../../../order/data/model/order_model.dart';
import '../../../order/presentation/provider/order_provider.dart';
import '../../../order/presentation/screen/order_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;
  final DateTime orderDate;
  const OrderDetailScreen({super.key, required this.orderId, required this.orderDate});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel? order;

  @override
  void initState() {
    super.initState();
    context.read<OrderProvider>().getOrderById(widget.orderId, widget.orderDate).then((value) {
      setState(() {
        order = value;
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
              if (payload.table == 'cart' || payload.table == 'orders') {
                if (payload.table == 'orders' && payload.eventType == PostgresChangeEvent.update) {
                  if (payload.oldRecord != null && payload.newRecord != null) {
                    if (payload.oldRecord!['status_id'] != payload.newRecord!['status_id'] && payload.newRecord!['id'] == widget.orderId) {
                      /*ElegantNotification.success(
                        width: 360,
                        position: Alignment.topRight,
                        animation: AnimationType.fromRight,
                        title: Text('Update', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, color: AppColor.darkGreyTextColor)),
                        description: Container(
                          child: Expanded(
                            child: Text('Order #${widget.orderId} has been updated successfully', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: AppColor.darkGreyTextColor)),
                          ),
                        ),
                        onDismiss: () {},
                      ).show(Get.context!);*/
                      /* Future.delayed(Duration(seconds: 1), () {
                        ElegantNotification.success(
                          width: 360,
                          position: Alignment.topRight,
                          animation: AnimationType.fromRight,
                          title: Text('Update', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, color: AppColor.darkGreyTextColor)),
                          description: Container(
                            child: Expanded(
                              child: Text('Order #${widget.orderId} has been updated successfully', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: AppColor.darkGreyTextColor)),
                            ),
                          ),
                          onDismiss: () {},
                        ).show(Get.key.currentContext!);
                      });*/
                    }
                  }
                }

                OrderModel? order = await context.read<OrderProvider>().getOrderById(widget.orderId, widget.orderDate);
                setState(() {
                  this.order = order;
                });
              }
              /*initData();*/
            })
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
      appBar: material.AppBar(
        elevation: 4,
        shadowColor: FluentTheme.of(context).shadowColor,
        surfaceTintColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        title: Text('Order #${widget.orderId}', style: FluentTheme.of(context).typography.subtitle),
      ),
      body: order == null
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: ProgressRing()),
            )
          : ResponsiveHelper.isDesktop(context)
              ? Container(
/*
                  color: Theme.of(context).scaffoldBackgroundColor,
*/
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: ProductsItemListView(
                          order: order!,
                        ),
                      ),
                      Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          CustomerHourWidget(
                            order: order!,
                          ),
                          StatusWithButtonWidget(
                            order: order!,
                          ),
                        ]),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
/*
                    color: Theme.of(context).scaffoldBackgroundColor,
*/
                      ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomerHourWidget(
                          order: order!,
                        ),
                        ProductsItemListView(
                          order: order!,
                        ),
                        StatusWithButtonWidget(
                          order: order!,
                        ),
                      ],
                    ),
                  ),
                ),
      persistentFooterButtons: order != null && (order!.status.step == 1 || order!.status.step == 2) && !ResponsiveHelper.isDesktop(context)
          ? [
              StatusButton(
                order: order!,
              )
            ]
          : null,
    );
  }
}

class StatusStepWidget extends StatefulWidget {
  OrderModel order;
  StatusStepWidget({super.key, required this.order});

  @override
  State<StatusStepWidget> createState() => _StatusStepWidgetState();
}

class _StatusStepWidgetState extends State<StatusStepWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                      child: Row(
                    children: [
                      if (widget.order.status.step > 1)
                        Container(
                          height: 40,
                          width: 40,
                          child: Icon(FluentIcons.check_mark, color: AppColor.completedForegroundColor, size: 40),
                        )
                      else
                        Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundColor: AppColor.pendingForegroundColor,
                            child: Text('1', style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 20, color: Colors.white)),
                          ),
                        ),
                      SizedBox(width: 10),
                      StatusWidget(
                        status: 'pending',
                      ),
                    ],
                  )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: // return 90 deg a divider
                              Container(
                            width: 2,
                            height: 30,
                            color: widget.order.status.step > 1 ? AppColor.completedForegroundColor : AppColor.lightCardColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('${DateHelper.getFormattedDateAndTime(widget.order.createdAt)}',
                            style: /*AppTextStyle.lightTextStyle(fontSize: 16),*/
                                FluentTheme.of(context).typography.body!.copyWith(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      child: Row(
                    children: [
                      if (widget.order.status.step > 2)
                        Container(
                          height: 40,
                          width: 40,
                          child: Icon(FluentIcons.check_mark, color: AppColor.completedForegroundColor, size: 40),
                        )
                      else
                        Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundColor: widget.order.status.step >= 2 ? AppColor.cookingForegroundColor : AppColor.lightCardColor,
                            child: Text(
                              '2',
                              style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      SizedBox(width: 10),
                      StatusWidget(
                        status: 'inProgress',
                      ),
                    ],
                  )),
                  if (widget.order.status.step >= 2)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            child: // return 90 deg a divider
                                Container(
                              width: 2,
                              height: 30,
                              color: widget.order.status.step > 2 ? AppColor.completedForegroundColor : AppColor.lightCardColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('${widget.order.cookingStartedAt != null ? DateHelper.getFormattedDateAndTime(widget.order.cookingStartedAt!) : ''}',
                              style: /*AppTextStyle.lightTextStyle(fontSize: 16)*/
                                  FluentTheme.of(context).typography.body!.copyWith(fontSize: 16)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (widget.order.status.step >= 2)
              Container(
                child: Column(
                  children: [
                    Container(
                        child: Row(
                      children: [
                        if (widget.order.status.step >= 3)
                          Container(
                            height: 40,
                            width: 40,
                            child: Icon(FluentIcons.check_mark, color: AppColor.completedForegroundColor, size: 40),
                          )
                        else
                          Container(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: widget.order.status.step >= 3 ? AppColor.completedForegroundColor : AppColor.lightCardColor,
                              child: Text(
                                '3',
                                style: AppTextStyle.boldTextStyle(fontSize: 20, color: widget.order.status.step >= 3 ? Colors.white : AppColor.lightGreyTextColor),
                              ),
                            ),
                          ),
                        SizedBox(width: 10),
                        StatusWidget(
                          status: 'completed',
                        ),
                      ],
                    )),
                    if (widget.order.status.step >= 3)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 40,
                              height: 40,
                              child: // return 90 deg a divider
                                  Container(
                                width: 2,
                                height: 30,
                                color: widget.order.status.step > 3 ? AppColor.completedForegroundColor : AppColor.lightCardColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('${DateHelper.getFormattedDateAndTime(widget.order.readyAt!)}', style: /*AppTextStyle.lightTextStyle(fontSize: 16)*/ FluentTheme.of(context).typography.body!.copyWith(fontSize: 16)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            if (widget.order.status.step >= 3)
              Container(
                child: Column(
                  children: [
                    Container(
                        child: Row(
                      children: [
                        if (widget.order.status.step >= 4)
                          Container(
                            height: 40,
                            width: 40,
                            child: Icon(FluentIcons.check_mark, color: AppColor.completedForegroundColor, size: 40),
                          )
                        else
                          Container(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: widget.order.status.step >= 4 ? AppColor.completedForegroundColor : AppColor.lightCardColor,
                              child: Text(
                                '4',
                                style: AppTextStyle.boldTextStyle(fontSize: 20, color: widget.order.status.step >= 4 ? Colors.white : AppColor.lightGreyTextColor),
                              ),
                            ),
                          ),
                        SizedBox(width: 10),
                        StatusWidget(
                          status: 'collected',
                        ),
                      ],
                    )),
                    if (widget.order.status.step >= 4)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                            ),
                            SizedBox(width: 10),
                            Text('${DateHelper.getFormattedDateAndTime(widget.order.collectedAt!)}', style: /*AppTextStyle.lightTextStyle(fontSize: 16)*/ FluentTheme.of(context).typography.body!.copyWith(fontSize: 16)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      )),
      SizedBox(height: 30),
      if ((widget.order.status.step == 1 || widget.order.status.step == 2) && ResponsiveHelper.isDesktop(context))
        StatusButton(
          order: widget.order,
        ),
    ]);
  }
}

class StatusButton extends StatefulWidget {
  OrderModel order;
  StatusButton({super.key, required this.order});

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: FilledButton(
        onPressed: () async {
          if (widget.order.status.step == 1) {
            bool? res = await showDialog<bool>(
              context: context,
              builder: (context) {
                return ContentDialog(
                  title: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Start cooking',
                      style: FluentTheme.of(context).typography.title!.copyWith(fontSize: 24),
                    ),
                  ),
                  content: Container(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FluentIcons.warning, size: 100, color: AppColor.canceledForegroundColor),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Are you sure you want to start cooking?\nYou will not be able to change the status once you start cooking.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'),
                    ),
                    Button(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('No'),
                    ),
                  ],
                );
              },
            );

            if (res != null && res) {
              context.read<OrderProvider>().changeOrderStatus(widget.order.id, widget.order.date, 2).whenComplete(() {
                ElegantNotification.success(
                  width: 360,
                  height: 100,
                  position: Alignment.topRight,
                  animation: AnimationType.fromRight,
                  title: Text('Update', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20, color: AppColor.darkGreyTextColor)),
                  description: Container(
                    child: Expanded(
                      child: Column(
                        children: [
                          Text('Order #${widget.order.id} has been updated successfully', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 16, color: AppColor.darkGreyTextColor)),
                        ],
                      ),
                    ),
                  ),
                  onDismiss: () {},
                ).show(context);
              });
            }
          } else {
            bool? res = await showDialog<bool>(
              context: context,
              builder: (context) {
                return ContentDialog(
                  title: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Mark as completed',
                      style: FluentTheme.of(context).typography.title!.copyWith(fontSize: 24),
                    ),
                  ),
                  content: Container(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.warning, size: 100, color: AppColor.canceledForegroundColor),
                        SizedBox(height: 10),
                        Text(
                          'Are you sure you want to mark as completed? If you do, all items in the cart will be marked as completed.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'),
                    ),
                    Button(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('No'),
                    ),
                  ],
                );
              },
            );

            if (res != null && res) {
              context.read<OrderProvider>().changeOrderStatus(widget.order.id, widget.order.date, 3);
              ElegantNotification.success(
                width: 360,
                height: 100,
                position: Alignment.topRight,
                animation: AnimationType.fromRight,
                title: Text('Update', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20, color: AppColor.darkGreyTextColor)),
                description: Container(
                  child: Expanded(
                    child: Column(
                      children: [
                        Text('Order #${widget.order.id} has been updated successfully', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 16, color: AppColor.darkGreyTextColor)),
                      ],
                    ),
                  ),
                ),
                onDismiss: () {},
              ).show(context);
            }
          }
        },
        child: Text(widget.order.status.step == 1 ? 'Start cooking' : 'Mark as completed'),
        style: ButtonStyle(
          foregroundColor: ButtonState.all(Colors.white),
          backgroundColor: ButtonState.resolveWith((states) {
            switch (states) {
              case ButtonStates.hovering:
                return AppColor.cookingForegroundColor;
              case ButtonStates.pressing:
                return AppColor.cookingForegroundColor;
              default:
                return AppColor.cookingForegroundColor;
            }
          }),
        ),
      ),
    );
  }
}

class ProductsItemListView extends StatelessWidget {
  OrderModel order;
  ProductsItemListView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    print('order.cart.length: ${order.cart.length}');
    return Card(
      padding: const EdgeInsets.all(0),
      margin: !ResponsiveHelper.isMobile(context) ? const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20) : EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Container(
        height: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height : null,
        /*decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),*/
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: FluentTheme.of(context).scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!,
                    width: 1,
                  ),
                ),
              ),
              child: Text('${order!.nbTotalItemsCart} items', style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 20) /*AppTextStyle.boldTextStyle(fontSize: 20)*/),
            ),
            if (ResponsiveHelper.isDesktop(context))
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: order!.cart.length,
                  itemBuilder: (context, index) {
                    return Card(
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Row(children: [
                          Container(
                            width: 100,
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: AppColor.lightCardColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Image.network(
                                    order!.cart[index].product.photoUrl ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(FluentIcons.eat_drink, size: 40),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${order!.cart[index].quantity}',
                                      style: /*AppTextStyle.boldTextStyle(
                                            fontSize: 24),*/
                                          FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 24),
                                    ),
                                  ),
                                ),
                                Text(
                                  'x',
                                  style: /*AppTextStyle.lightTextStyle(
                                          fontSize: 14)*/
                                      FluentTheme.of(context).typography.body!.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text('${order!.cart[index].product.name}', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                          ),
                          /*  AppTextStyle.boldTextStyle(fontSize: 16)),*/
                        ]),
                        trailing: Container(
                          height: 36,
                          width: 36,
                          child: Checkbox(
                            style: CheckboxThemeData(
                              checkedIconColor: ButtonState.all(Colors.white),
                              checkedDecoration: ButtonState.all(BoxDecoration(
                                color: AppColor.completedForegroundColor,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: FluentTheme.of(context).shadowColor.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 0.5),
                                  ),
                                ],
                              )),
                              uncheckedDecoration: ButtonState.all(BoxDecoration(
                                color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: FluentTheme.of(context).shadowColor.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 0.5),
                                  ),
                                ],
                              )),
                            ),
                            checked: order!.cart[index].isDone,
                            onChanged: order!.status.step == 2
                                ? (value) {
                                    print('value: $value');
                                    int cartId = order!.cart[index].id!;
                                    print('cartId: $cartId');
                                    order!.cart[index].isDone = value ?? false;
                                    context.read<OrderProvider>().changeIsDoneCart(order!.id, cartId, order!.cart[index].product.id, order!.date, value ?? false);
                                  }
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Column(
                children: List.generate(order.cart.length, (index) {
                  print('order.cart.length: ${order.cart.length}');
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      /* enabled: order!.status.step == 2,
                          activeColor: AppColor.completedForegroundColor,*/
                      title: Row(children: [
                        Container(
                          width: 100,
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: AppColor.lightCardColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Image.network(
                                  order!.cart[index].product.photoUrl ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(FluentIcons.eat_drink, size: 40),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text('${order!.cart[index].quantity}',
                                      style: /*AppTextStyle.boldTextStyle(
                                            fontSize: 24),*/
                                          FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 24)),
                                ),
                              ),
                              Text(
                                'x',
                                style: /*AppTextStyle.lightTextStyle(
                                          fontSize: 14)*/
                                    FluentTheme.of(context).typography.body!.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text('${order!.cart[index].product.name}', style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20)),
                        ),
                        /*  AppTextStyle.boldTextStyle(fontSize: 16)),*/
                      ]),
                      trailing: Container(
                        height: 36,
                        width: 36,
                        child: Checkbox(
                          style: CheckboxThemeData(
                            checkedIconColor: ButtonState.all(Colors.white),
                            checkedDecoration: ButtonState.all(BoxDecoration(
                              color: AppColor.completedForegroundColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: FluentTheme.of(context).shadowColor.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 0.5),
                                ),
                              ],
                            )),
                            uncheckedDecoration: ButtonState.all(BoxDecoration(
                              color: FluentTheme.of(context).navigationPaneTheme.backgroundColor!,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: FluentTheme.of(context).shadowColor.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 0.5),
                                ),
                              ],
                            )),
                          ),
                          checked: order!.cart[index].isDone,
                          onChanged: order!.status.step == 2
                              ? (value) {
                                  print('value: $value');
                                  int cartId = order!.cart[index].id!;
                                  print('cartId: $cartId');
                                  order!.cart[index].isDone = value ?? false;
                                  context.read<OrderProvider>().changeIsDoneCart(order!.id, cartId, order!.cart[index].product.id, order!.date, value ?? false);
                                }
                              : null,
                        ),
                      ),
                    ),

                    /*Divider(
                          color: Theme.of(context).dividerColor,
                        )*/
                  );
                }),
              )
          ],
        ),
      ),
    );
  }
}

class CustomerHourWidget extends StatelessWidget {
  OrderModel order;
  CustomerHourWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(0),
      margin: !ResponsiveHelper.isMobile(context)
          ? const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20)
          : const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
      /* decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),*/
      child: Row(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(FluentIcons.contact, size: 50),
                Expanded(
                  child: Container(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        'Customer',
                        style: /*AppTextStyle.lightTextStyle(fontSize: 12)*/
                            FluentTheme.of(context).typography.body!.copyWith(fontSize: 12),
                      ),
                      Container(
                        child: Text(
                          '${order!.customer.lName} ${order!.customer.fName}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20),
                        ),
                      ),
                    ]),
                  ),
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
                Icon(FluentIcons.clock, size: 50),
                Container(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Hour',
                        style: /*AppTextStyle.lightTextStyle(fontSize: 12)),*/
                            FluentTheme.of(context).typography.body),
                    Text(
                      '${order!.time.hour < 10 ? '0${order!.time.hour}' : order!.time.hour} : ${order!.time.minute < 10 ? '0${order!.time.minute}' : order!.time.minute}',
                      style: FluentTheme.of(context).typography.body!.copyWith(fontSize: 20),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class StatusWithButtonWidget extends StatelessWidget {
  OrderModel order;
  StatusWithButtonWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(20),
      margin: !ResponsiveHelper.isMobile(context) ? const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20) : EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: order.status.step * 90 + 120,
        ),
        // decoration: BoxDecoration(
        //   color: FluentTheme.of(context).cardColor,
        //   borderRadius: BorderRadius.circular(16),
        // ),
        child: StatusStepWidget(
          order: order!,
        ),
      ),
    );
  }
}
