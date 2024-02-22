import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
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
  const OrderDetailScreen(
      {super.key, required this.orderId, required this.orderDate});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel? order;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context
        .read<OrderProvider>()
        .getOrderById(widget.orderId, widget.orderDate)
        .then((value) {
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
                if (payload.table == 'orders' &&
                    payload.eventType == PostgresChangeEvent.update) {
                  if (payload.oldRecord != null && payload.newRecord != null) {
                    if (payload.oldRecord!['status_id'] !=
                            payload.newRecord!['status_id'] &&
                        payload.newRecord!['id'] == widget.orderId) {
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

                OrderModel? order = await context
                    .read<OrderProvider>()
                    .getOrderById(widget.orderId, widget.orderDate);
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        title: Text('Order #${widget.orderId}',
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 32)),
      ),
      body: order == null
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            )
          : !ResponsiveHelper.isMobile(context)
              ? Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
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
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomerHourWidget(
                                order: order!,
                              ),
                              Spacer(),
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
                    color: Theme.of(context).scaffoldBackgroundColor,
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
      persistentFooterButtons: order != null &&
              (order!.status.step == 1 || order!.status.step == 2) &&
              ResponsiveHelper.isMobile(context)
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
                          child: Icon(Icons.check_circle,
                              color: AppColor.completedForegroundColor,
                              size: 40),
                        )
                      else
                        Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundColor: AppColor.pendingForegroundColor,
                            child: Text('1',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize: 20,
                                        color: widget.order.status.step >= 1
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : AppColor.lightGreyTextColor)),
                          ),
                        ),
                      SizedBox(width: 10),
                      StatusWidget(
                        status: 'Pending',
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
                            color: widget.order.status.step > 1
                                ? AppColor.completedForegroundColor
                                : AppColor.lightCardColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                            '${DateHelper.getFormattedDateAndTime(widget.order.createdAt)}',
                            style: /*AppTextStyle.lightTextStyle(fontSize: 16),*/
                                Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 16)),
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
                          child: Icon(Icons.check_circle,
                              color: AppColor.completedForegroundColor,
                              size: 40),
                        )
                      else
                        Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundColor: widget.order.status.step >= 2
                                ? AppColor.cookingForegroundColor
                                : AppColor.lightCardColor,
                            child: Text(
                              '2',
                              style: AppTextStyle.boldTextStyle(
                                  fontSize: 20,
                                  color: widget.order.status.step >= 2
                                      ? Theme.of(context).primaryColor
                                      : AppColor.lightGreyTextColor),
                            ),
                          ),
                        ),
                      SizedBox(width: 10),
                      StatusWidget(
                        status: 'Cooking',
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
                              color: widget.order.status.step > 2
                                  ? AppColor.completedForegroundColor
                                  : AppColor.lightCardColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                              '${widget.order.cookingStartedAt != null ? DateHelper.getFormattedDateAndTime(widget.order.cookingStartedAt!) : ''}',
                              style: /*AppTextStyle.lightTextStyle(fontSize: 16)*/
                                  Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontSize: 16)),
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
                            child: Icon(Icons.check_circle,
                                color: AppColor.completedForegroundColor,
                                size: 40),
                          )
                        else
                          Container(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: widget.order.status.step >= 3
                                  ? AppColor.completedForegroundColor
                                  : AppColor.lightCardColor,
                              child: Text(
                                '3',
                                style: AppTextStyle.boldTextStyle(
                                    fontSize: 20,
                                    color: widget.order.status.step >= 3
                                        ? Theme.of(context).primaryColor
                                        : AppColor.lightGreyTextColor),
                              ),
                            ),
                          ),
                        SizedBox(width: 10),
                        StatusWidget(
                          status: 'Completed',
                        ),
                      ],
                    )),
                    if (widget.order.status.step >= 3)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                            ),
                            SizedBox(width: 10),
                            Text(
                                '${DateHelper.getFormattedDateAndTime(widget.order.readyAt!)}',
                                style:
                                    /*AppTextStyle.lightTextStyle(fontSize: 16)*/ Theme
                                            .of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 16)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      )),
      if ((widget.order.status.step == 1 || widget.order.status.step == 2) &&
          !ResponsiveHelper.isMobile(context))
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
    return MaterialButton(
      onPressed: () {
        if (widget.order.status.step == 1) {
          Get.dialog(AlertDialog(
            icon: Icon(Icons.warning, color: Colors.red, size: 100),
            iconColor: Colors.red,
            titleTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 24),
            contentTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
            title: Text('Start cooking'),
            content: Text('Are you sure you want to start cooking?'),
            actionsAlignment: MainAxisAlignment.spaceAround,
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
                  print('order id: ${widget.order.id}');
                  Get.back();
                  context
                      .read<OrderProvider>()
                      .changeOrderStatus(widget.order.id, widget.order.date, 2)
                      .whenComplete(() {
                    print('order id: ${widget.order.id}');

                    ElegantNotification.success(
                      width: 360,
                      height: 100,
                      position: Alignment.topRight,
                      animation: AnimationType.fromRight,
                      title: Text('Update',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 20,
                                  color: AppColor.darkGreyTextColor)),
                      description: Container(
                        child: Expanded(
                          child: Column(
                            children: [
                              Text(
                                  'Order #${widget.order.id} has been updated successfully',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize: 16,
                                          color: AppColor.darkGreyTextColor)),
                            ],
                          ),
                        ),
                      ),
                      onDismiss: () {},
                    ).show(context);
                  });
                },
                child: Text('Yes'),
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
                  Get.back();
                },
                child: Text('No'),
              ),
            ],
          ));
        } else {
          Get.dialog(AlertDialog(
            icon: Icon(Icons.warning, color: Colors.red, size: 100),
            iconColor: Colors.red,
            titleTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 24),
            contentTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
            title: Text('Mark as completed'),
            content: Container(
              constraints: BoxConstraints(
                maxWidth: 400,
              ),
              child: Text(
                'Are you sure you want to mark as completed? If you do, all items in the cart will be marked as completed.',
                textAlign: TextAlign.center,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: AppColor.completedForegroundColor,
                textColor: Theme.of(context).primaryColor,
                minWidth: 100,
                height: 40,
                onPressed: () {
                  Get.back();
                  context
                      .read<OrderProvider>()
                      .changeOrderStatus(widget.order.id, widget.order.date, 3);
                  ElegantNotification.success(
                    width: 360,
                    height: 100,
                    position: Alignment.topRight,
                    animation: AnimationType.fromRight,
                    title: Text('Update',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 20, color: AppColor.darkGreyTextColor)),
                    description: Container(
                      child: Expanded(
                        child: Column(
                          children: [
                            Text(
                                'Order #${widget.order.id} has been updated successfully',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 16,
                                        color: AppColor.darkGreyTextColor)),
                          ],
                        ),
                      ),
                    ),
                    onDismiss: () {},
                  ).show(context);
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
                  Get.back();
                },
                child: Text(
                  'No',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                      ),
                ),
              ),
            ],
          ));
        }
      },
      child: Text(
          widget.order.status.step == 1 ? 'Start cooking' : 'Mark as completed',
          style: AppTextStyle.boldTextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.secondary)),
      color: widget.order.status.step == 1
          ? AppColor.cookingForegroundColor
          : AppColor.completedForegroundColor,
      height: 60,
      minWidth: double.infinity,
    );
  }
}

class ProductsItemListView extends StatelessWidget {
  OrderModel order;
  ProductsItemListView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: !ResponsiveHelper.isMobile(context)? const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20) : EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        height: !ResponsiveHelper.isMobile(context)? MediaQuery.of(context).size.height : null,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1,
                  ),
                ),
              ),
              child: Text('${order!.nbTotalItemsCart} items',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize:
                          20) /*AppTextStyle.boldTextStyle(fontSize: 20)*/),
            ),
            if(!ResponsiveHelper.isMobile(context))
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: order!.cart.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          enabled: order!.status.step == 2,
                          activeColor: AppColor.completedForegroundColor,
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
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                              Icons.fastfood_rounded,
                                              size: 40),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${order!.cart[index].quantity}',
                                        style: /*AppTextStyle.boldTextStyle(
                                            fontSize: 24),*/
                                            Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'x',
                                    style: /*AppTextStyle.lightTextStyle(
                                          fontSize: 14)*/
                                        Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text('${order!.cart[index].product.name}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 20)),
                            ),
                            /*  AppTextStyle.boldTextStyle(fontSize: 16)),*/
                          ]),
                          value: order!.cart[index].isDone,
                          onChanged: (value) {
                            print('value: $value');
                            int cartId = order!.cart[index].id!;
                            print('cartId: $cartId');
                            context.read<OrderProvider>().changeIsDoneCart(
                                order!.id,
                                cartId,
                                order!.cart[index].product.id,
                                order!.date,
                                value!);
                          },
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                        )
                      ],
                    ),
                  );
                },
              ),
            )else
              Column(
                children: List.generate(order.cart.length, (index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          enabled: order!.status.step == 2,
                          activeColor: AppColor.completedForegroundColor,
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
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                          Icons.fastfood_rounded,
                                          size: 40),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${order!.cart[index].quantity}',
                                        style: /*AppTextStyle.boldTextStyle(
                                            fontSize: 24),*/
                                        Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'x',
                                    style: /*AppTextStyle.lightTextStyle(
                                          fontSize: 14)*/
                                    Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text('${order!.cart[index].product.name}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 20)),
                            ),
                            /*  AppTextStyle.boldTextStyle(fontSize: 16)),*/
                          ]),
                          value: order!.cart[index].isDone,
                          onChanged: (value) {
                            print('value: $value');
                            int cartId = order!.cart[index].id!;
                            print('cartId: $cartId');
                            context.read<OrderProvider>().changeIsDoneCart(
                                order!.id,
                                cartId,
                                order!.cart[index].product.id,
                                order!.date,
                                value!);
                          },
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                        )
                      ],
                    ),
                  );
                }),
              )
          ],
        ));
  }
}

class CustomerHourWidget extends StatelessWidget {
  OrderModel order;
  CustomerHourWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: !ResponsiveHelper.isMobile(context)? const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20) : const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.person_outlined, size: 50),
                Expanded(
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer',
                            style: /*AppTextStyle.lightTextStyle(fontSize: 12)*/
                                Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 12),
                          ),
                          Container(
                            child: Text(
                              '${order!.customer.lName} ${order!.customer.fName}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 20),
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
                Icon(Icons.access_time_outlined, size: 50),
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hour',
                            style: /*AppTextStyle.lightTextStyle(fontSize: 12)),*/
                                Theme.of(context).textTheme.bodySmall),
                        Text(
                          '${order!.time.hour < 10 ? '0${order!.time.hour}' : order!.time.hour} : ${order!.time.minute < 10 ? '0${order!.time.minute}' : order!.time.minute}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 20),
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
    return Container(
      padding: const EdgeInsets.all(20),
      margin: !ResponsiveHelper.isMobile(context)? const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20) : EdgeInsets.only(left: 10, right: 10, bottom: 20),
      constraints: BoxConstraints(
        maxHeight: order.status.step * 90 + 90,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: StatusStepWidget(
        order: order!,
      ),
    );
  }
}
