import 'package:cooker_app/src/core/constant/app_color.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text('Order #${widget.orderId}',
            style: AppTextStyle.boldTextStyle(fontSize: 32)),
      ),
      body: order == null
          ? Container(
              color: AppColor.lightCardColor,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            )
          : !ResponsiveHelper.isMobile(context)
              ? Container(
                  color: AppColor.lightCardColor,
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
                    color: AppColor.lightCardColor,
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
                                style: AppTextStyle.boldTextStyle(
                                    fontSize: 20,
                                    color: widget.order.status.step >= 1
                                        ? Theme.of(context).primaryColor
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
                            style: AppTextStyle.lightTextStyle(fontSize: 16)),
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
                              style: AppTextStyle.lightTextStyle(fontSize: 16)),
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
                                    AppTextStyle.lightTextStyle(fontSize: 16)),
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

class StatusButton extends StatelessWidget {
  OrderModel order;
  StatusButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (order.status.step == 1) {
          showAdaptiveDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  icon: Icon(Icons.warning, color: Colors.red, size: 100),
                  iconColor: Colors.red,
                  title: Text('Start cooking'),
                  content: Text('Are you sure you want to start cooking?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<OrderProvider>()
                            .changeOrderStatus(order.id, order.date, 2);
                        Navigator.of(context).pop();
                      },
                      child: Text('Start cooking'),
                    ),
                  ],
                );
              });
        } else {
          /* context
                  .read<OrderProvider>()
                  .changeOrderStatus(widget.order.id, widget.order.date, 3);*/

          showAdaptiveDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  icon: Icon(Icons.warning, color: Colors.red, size: 100),
                  iconColor: Colors.red,
                  title: Text('Mark as completed'),
                  content: Text(
                      'Are you sure you want to mark as completed? If you do, all items in the cart will be marked as completed.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<OrderProvider>()
                            .changeOrderStatus(order.id, order.date, 3);
                        Navigator.of(context).pop();
                      },
                      child: Text('Mark as completed'),
                    ),
                  ],
                );
              });
        }
      },
      child: Text(
          order.status.step == 1 ? 'Start cooking' : 'Mark as completed',
          style: AppTextStyle.boldTextStyle(
              fontSize: 20, color: Theme.of(context).primaryColor)),
      color: order.status.step == 1
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
        margin: const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
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
              child: Text('${order!.nbTotalItemsCart} items',
                  style: AppTextStyle.boldTextStyle(fontSize: 20)),
            ),
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
                            SizedBox(width: 10),
                            Text('${order!.cart[index].product.name}',
                                style:
                                    AppTextStyle.boldTextStyle(fontSize: 16)),
                          ]),
                          checkColor: AppColor.lightBackgroundColor,
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
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
                          color: AppColor.lightCardColor,
                        )
                      ],
                    ),
                  );
                },
              ),
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
      margin: const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
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
                Expanded(
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer',
                              style: AppTextStyle.lightTextStyle(fontSize: 12)),
                          Container(
                            child: Text(
                              '${order!.customer.lName} ${order!.customer.fName}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.boldTextStyle(fontSize: 20),
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
                            style: AppTextStyle.lightTextStyle(fontSize: 12)),
                        Text(
                            '${order!.time.hour < 10 ? '0${order!.time.hour}' : order!.time.hour} : ${order!.time.minute < 10 ? '0${order!.time.minute}' : order!.time.minute}',
                            style: AppTextStyle.boldTextStyle(fontSize: 20)),
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
      margin: const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: AppColor.lightBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: StatusStepWidget(
        order: order!,
      ),
    );
  }
}
